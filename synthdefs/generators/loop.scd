(
SynthDef(\loop, {
	arg buf, out, amp, hpf, lpf, lpfFreq, hpfFreq, lpfOn, hpfOn, masterAmp, gate, route0, route1, route2, route3, route4, route5, route6, route7;
	var sig, env;
	var route = [ route0, route1, route2, route3, route4, route5, route6, route7];

	sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf), 1, 0, 1, 2);

	sig = Select.ar(lpfOn.lag(0.005), [sig, LPF.ar(sig, lpfFreq.lag(0.005))]);
	sig = Select.ar(hpfOn.lag(0.005), [sig, HPF.ar(sig, hpfFreq.lag(0.005))]);

	env = EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = sig * amp * masterAmp * env;
	sig = sig*route;

	Out.ar(out, sig);
}).add;
);

