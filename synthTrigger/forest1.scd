(
~forestSynths.add(\forest1 ->
	Synth(\forestTrig1,
		[
			\trigRate, ~params[\forest1][\trigRate], \amp, ~params[\forest1][\amp],
			\posLow, ~params[\forest1][\posLow], \posHigh, ~params[\forest1][\posHigh],
			\rateLow, ~params[\forest1][\rateLow], \rateHigh, ~params[\forest1][\rateHigh],
			\durLow, ~params[\forest1][\durLow], \durHigh, ~params[\forest1][\durHigh],
			\pan, ~params[\forest1][\pan],
			\sizeLow, ~params[\forest1][\sizeLow], \sizeHigh, ~params[\forest1][\sizeHigh],
			\hpf, ~params[\forest1][\hpf], \lpf, ~params[\forest1][\lpf],
			\atkLow, ~params[\forest1][\atkLow], \atkHigh, ~params[\forest1][\atkHigh], \relLow, ~params[\forest1][\relLow], \relHigh, ~params[\forest1][\relHigh],
			\out, ~params[\forestOut]
		], ~nodes[\forest]
	).register;
);

OSCFunc({ arg msg, time;
	var buf;
	Synth(\forest, [
		\buf, ~buffers[\forest1][~buffers[\forest1].size.rand], \out, ~params[\forestOut], \amp, msg[12],
		\posLow, msg[3], \posHigh, msg[4],
		\rateLow, msg[5], \rateHigh, msg[6],
		\durLow, msg[7], \durHigh, msg[8],
		\pan, msg[9],
		\sizeLow, msg[10], \sizeHigh, msg[11],
		\atkLow, msg[15], \atkHigh, msg[16], \relLow, msg[17], \relHigh, msg[18],
		\hpf, msg[13], \lpf, msg[14], \masterAmp, ~masterAmp
	], ~nodes[\forest], 'addToTail');

}, '/forest1', s.addr);
);

