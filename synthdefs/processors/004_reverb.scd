(
SynthDef(\reverb, {
	arg gate, receive0=1, receive1=1, receive2=1, receive3=1,receive4=0, amp, masterAmp, in0, in1, in2, in3, in4, dampFreqLow = 12000, dampFreqHigh=18000, combDelayLow=0.02, combDelayHigh=0.07, combDecay=0.7, delayLow=0.01, delayHigh=0.05, decayTime=1, preDelay=0.048, hpf=100, lpf=20000, out=0;
	var in, numc, numa, temp, sig, env;

	in = Mix([
		In.ar(in0, 2)*receive0,
		In.ar(in1, 2)*receive1,
		In.ar(in2, 2)*receive2,
		In.ar(in3, 2)*receive3,
		In.ar(in4, 2)*receive4,
	]);

	numc = 4; // number of comb delays
	numa = 6; // number of allpass delays

	// reverb predelay time
	temp = DelayN.ar(in, 0.1, 0.048);
	temp=Mix.fill(numc,
		{
			CombL.ar(temp, 0.1, {Rand(combDelayLow, combDelayHigh)}, combDecay)};
	);

	// chain of 4 allpass delays on each of two channels (8 total) :
	numa.do({
		temp = AllpassL.ar(temp, 0.1, {Rand(delayLow, delayHigh)}!2, decayTime);
		sig = LPF.ar(temp, {Rand(dampFreqLow, dampFreqHigh)});
	});

	sig = HPF.ar(sig, hpf);
	sig = LPF.ar(sig, lpf);

	env =  EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = sig * env * amp * masterAmp * 0.3;

	Out.ar(out, sig);
}).add;
);
