(
// also 4096 works on my machine; 1024 too often and amortisation too pushed, 8192 more high load FFT
{
	var irBufs = Array.newClear(2), fftsize = (1024*2);


	(~buffers[\impulseResponse].size+1).do{|i|
		if(i<(~buffers[\impulseResponse].size), {
			{
				var ir, irbufferL, irbufferR;

				irbufferL = Buffer.readChannel(s, (~path[\buffers]++"impulseResponse"+/+~buffersNames[\impulseResponse][i].asString++".wav"), channels: [0]);
				irbufferR = Buffer.readChannel(s, (~path[\buffers]++"impulseResponse"+/+~buffersNames[\impulseResponse][i].asString++".wav"), channels: [1]);

				s.sync;

				irBufs[i] = Buffer.alloc(s, PartConv.calcBufSize(fftsize, irbufferL), 1);
				irBufs[i].preparePartConv(irbufferL, fftsize);

				irBufs[i+1] = Buffer.alloc(s, PartConv.calcBufSize(fftsize, irbufferR), 1);
				irBufs[i+1].preparePartConv(irbufferR, fftsize);

				s.sync;

				irbufferL.free; // don't need time domain data anymore, just needed spectral version
				irbufferR.free; // don't need time domain data anymore, just needed spectral version
			}.value;
		}, {

			SynthDef(\convolution, {
				arg in0, out, amp, gate, masterAmp, hpf, lpf, bitDepthLow=8, bitDepthHigh=16;
				var in, sig, sig0, sig1, env, bitDepth, rms;

				in = In.ar(in0, 2);
				in = HPF.ar(in, 120);

				rms = RMS.kr(in).linlin(0.0, 0.2, 0.0, 1.0);
				bitDepth = rms.linexp(0.0, 1.0, bitDepthHigh, bitDepthLow);

				in = Decimator.ar(in, s.sampleRate, bitDepth);

				sig0= PartConv.ar(in, fftsize, irBufs[0].bufnum, 0.1);
				sig1= PartConv.ar(in, fftsize, irBufs[1].bufnum, 0.1);

				sig= [sig0, sig1];

				env =  EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

				sig = HPF.ar(sig, hpf);
				sig = LPF.ar(sig, lpf);

				sig = sig * env * amp * masterAmp;

				Out.ar(out, sig);
			}).add;
		});
	};
}.fork;
);

//Synth(\impulseResponse);