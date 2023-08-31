(
SynthDef(\sine, {
	arg buf, out, amp, masterAmp, gate, freq, route0, route1, route2, route3, route4, route5, route6, route7;
	var sig, env;
	var route = [ route0, route1, route2, route3, route4, route5, route6, route7];

	sig = SinOsc.ar(freq, {Rand(0, 2pi)}, 0.4);

	env = EnvGen.kr(Env.asr(0.05, 1, 0.05), gate, doneAction: 2);

	sig = sig * amp.lag(0.05) * masterAmp * env;

	sig = sig*route;

	Out.ar(out, sig);p
}).add;
);

