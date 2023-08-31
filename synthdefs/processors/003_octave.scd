(
SynthDef(\octaver, {
	arg gate, receive0=1, receive1=1, receive2=1, receive3=1,receive4=0, maxdel=0.05, amp, masterAmp, in0, in1, in2, in3, in4, out=0, numOctaves, hpf=20, lpf=20000;
	var in, env, sig, phasor, sigEnv, semiTone;

	in = Mix([
		In.ar(in0, 2)*receive0,
		In.ar(in1, 2)*receive1,
		In.ar(in2, 2)*receive2,
		In.ar(in3, 2)*receive3,
		In.ar(in4, 2)*receive4,
	]);

	semiTone = Select.kr(numOctaves.lag(0.1), [-12, -24]);

	phasor = LFSaw.ar(semiTone.neg, [1, 0]!2).range(0, maxdel);
	sigEnv = SinOsc.ar(semiTone, [3pi/2, pi/2]!2).range(0, 1).sqrt;
	sig = DelayC.ar(in, maxdel, phasor) * sigEnv;
	sig = [sig[0][0]+sig[0][1], sig[1][0]+sig[1][1]];

	env =  EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = sig * env * amp * masterAmp;

	sig = HPF.ar(sig, hpf);
	sig = LPF.ar(sig, lpf);

	Out.ar(out, sig);
}).add;
);

