(
SynthDef(\harmonizer, {
	arg gate, receive0=1, receive1=1, receive2=1, receive3=1,receive4=0, amp, masterAmp, in0, in1, in2, in3, in4, out=0, numVoices=0, ratio0=0, ratio1=0, ratio2=0, ratio3=0, maxdel=0.05, hpf=20, lpf=20000;
	var in, env, sig, sig0, sig1, sig2, sig3, phasor0, phasor1, phasor2, phasor3, sigEnv0, sigEnv1, sigEnv2, sigEnv3;

	in = Mix([
		In.ar(in0, 2)*receive0,
		In.ar(in1, 2)*receive1,
		In.ar(in2, 2)*receive2,
		In.ar(in3, 2)*receive3,
		In.ar(in4, 2)*receive4,
	]);

	phasor0 = LFSaw.ar(ratio0.neg, [1, 0]!2).range(0, maxdel);
	sigEnv0 = SinOsc.ar(ratio0, [3pi/2, pi/2]!2).range(0, 1).sqrt;
	sig0 = DelayC.ar(in, maxdel, phasor0) * sigEnv0;
	sig0 = [sig0[0][0]+sig0[0][1], sig0[1][0]+sig0[1][1]];

	phasor1 = LFSaw.ar(ratio1.neg, [1, 0]!2).range(0, maxdel);
	sigEnv1 = SinOsc.ar(ratio1, [3pi/2, pi/2]!2).range(0, 1).sqrt;
	sig1 = DelayC.ar(in, maxdel, phasor1) * sigEnv1;
	sig1 = [sig1[0][0]+sig1[0][1], sig1[1][0]+sig1[1][1]];

	phasor2 = LFSaw.ar(ratio2.neg, [1, 0]!2).range(0, maxdel);
	sigEnv2 = SinOsc.ar(ratio2, [3pi/2, pi/2]!2).range(0, 1).sqrt;
	sig2 = DelayC.ar(in, maxdel, phasor2) * sigEnv2;
	sig2 = [sig2[0][0]+sig2[0][1], sig2[1][0]+sig2[1][1]];

	phasor3 = LFSaw.ar(ratio3.neg, [1, 0]!2).range(0, maxdel);
	sigEnv3 = SinOsc.ar(ratio3, [3pi/2, pi/2]!2).range(0, 1).sqrt;
	sig3 = DelayC.ar(in, maxdel, phasor3) * sigEnv3;
	sig3 = [sig3[0][0]+sig3[0][1], sig3[1][0]+sig3[1][1]];


	sig = Select.ar(numVoices.lag(0.005),
		[
			Mix.ar([sig0]),
			Mix.ar([sig0, sig1]),
			Mix.ar([sig0, sig1, sig2]),
			Mix.ar([sig0, sig1, sig2, sig3])
		]
	);

	env =  EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = sig * env * amp * masterAmp;

	sig = HPF.ar(sig, hpf);
	sig = LPF.ar(sig, lpf);

	Out.ar(out, sig);
}).add;
);

