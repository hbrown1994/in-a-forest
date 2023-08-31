(
SynthDef(\oneShot, {
	arg buf, out, amp, hpf, lpf, lpfFreq, hpfFreq, lpfOn, hpfOn, masterAmp, route0, route1, route2, route3, route4, route5, route6, route7, t_trig=0;
	var sig, toggle;
	var route = [ route0, route1, route2, route3, route4, route5, route6, route7];

	toggle = ToggleFF.kr(t_trig);

	sig =
	(PlayBuf.ar(1, buf, BufRateScale.kr(buf), Trig.kr(toggle), 0, 0)*toggle.lag(0.005))+
	(PlayBuf.ar(1, buf, BufRateScale.kr(buf), Trig.kr(toggle.linlin(0, 1, 1, 0)), 0, 0)*toggle.linlin(0, 1, 1, 0).lag(0.005));

	EnvGen.kr(Env.linen(0, BufFrames.kr(buf)/SampleRate.ir, 0), t_trig, doneAction: 2);

	sig = Select.ar(lpfOn.lag(0.005), [sig, LPF.ar(sig, lpfFreq.lag(0.005))]);
	sig = Select.ar(hpfOn.lag(0.005), [sig, HPF.ar(sig, hpfFreq.lag(0.005))]);

	sig = sig * amp * masterAmp;

	sig = sig*route;

	Out.ar(out, sig);
}).add;
);

