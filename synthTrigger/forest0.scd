(
~forestSynths.add(\forest0 ->
	Synth(\forestTrig0,
		[
			\trigRate, ~params[\forest0][\trigRate], \amp, ~params[\forest0][\amp],
			\posLow, ~params[\forest0][\posLow], \posHigh, ~params[\forest0][\posHigh],
			\rateLow, ~params[\forest0][\rateLow], \rateHigh, ~params[\forest0][\rateHigh],
			\durLow, ~params[\forest0][\durLow], \durHigh, ~params[\forest0][\durHigh],
			\pan, ~params[\forest0][\pan],
			\sizeLow, ~params[\forest0][\sizeLow], \sizeHigh, ~params[\forest0][\sizeHigh],
			\hpf, ~params[\forest0][\hpf], \lpf, ~params[\forest0][\lpf],
			\atkLow, ~params[\forest0][\atkLow], \atkHigh, ~params[\forest0][\atkHigh], \relLow, ~params[\forest0][\relLow], \relHigh, ~params[\forest0][\relHigh],
			\out, ~params[\forestOut]
		], ~nodes[\forest]
	).register;
);

OSCFunc({ arg msg, time;
	var buf;
	Synth(\forest, [
		\buf, ~buffers[\forest0][~buffers[\forest0].size.rand], \out, ~params[\forestOut], \amp, msg[12],
		\posLow, msg[3], \posHigh, msg[4],
		\rateLow, msg[5], \rateHigh, msg[6],
		\durLow, msg[7], \durHigh, msg[8],
		\pan, msg[9],
		\sizeLow, msg[10], \sizeHigh, msg[11],
		\atkLow, msg[15], \atkHigh, msg[16], \relLow, msg[17], \relHigh, msg[18],
		\hpf, msg[13], \lpf, msg[14], \masterAmp, ~masterAmp
	], ~nodes[\forest], 'addToTail');

}, '/forest0', s.addr);
);

