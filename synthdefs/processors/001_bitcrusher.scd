(
SynthDef(\bitCrusher, {
	arg gate, receive0=1, receive1=1, receive2=1, receive3=1,receive4=0, amp, masterAmp, in0, in1, in2, in3, in4, out=0, sampleRate=44100, bitDepth=16, hpf=20, lpf=20000;
	var in, env, sig;

	in = Mix([
		In.ar(in0, 2)*receive0,
		In.ar(in1, 2)*receive1,
		In.ar(in2, 2)*receive2,
		In.ar(in3, 2)*receive3,
		In.ar(in4, 2)*receive4,
	]);

	sig = Decimator.ar(in, sampleRate, bitDepth);

	env =  EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = sig * env * amp * masterAmp;

	sig = HPF.ar(sig, hpf);
	sig = LPF.ar(sig, lpf);

	Out.ar(out, sig);
}).add;
);