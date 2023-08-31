SynthDef(\forest, {
	arg buf, amp=1, out, durLow, durHigh, posLow, posHigh, rateLow, rateHigh, pan, sizeLow, sizeHigh, lpf=20000, hpf=20, atkLow, atkHigh, relLow, relHigh, masterAmp;
	var in, sig, sigL, sigR, env, start, dur, panSel, size, atk, rel, lineDur, randSpeakers, crossPanSig0, crossPanSig1, panType;

	size = {Rand(sizeLow, sizeHigh)};
	size = (size*SampleRate.ir).asInteger;
	start = {Rand(0.0, 1.0)}.linlin(0.0, 1.0, 0.0, (BufFrames.kr(buf)-size)).asInteger;
	dur = {Rand(durLow, durHigh)};
	atk = {Rand(atkLow, atkHigh)};
	rel = {Rand(relLow, relHigh)};

	lineDur = atk + rel + dur;

	env = EnvGen.kr(Env.linen(atk, dur, rel, 1, [-4, 4]), 1, doneAction: 2);

	in = LoopBuf.ar(
	2,
	buf,
	(BufRateScale.kr(buf)*{Rand(rateLow, rateHigh)}),
	1,
	Wrap.kr(start, 0, BufFrames.kr(buf)),
	Wrap.kr(start, 0, BufFrames.kr(buf)),
	Wrap.kr((start+size), 0, BufFrames.kr(buf))
	);

	in = in * env * amp * masterAmp;

	in = LPF.ar(in, lpf);
	in = HPF.ar(in, hpf);

	panSel = TWindex.kr(Impulse.kr(0), [pan.linlin(0, 1, 1, 0), pan]);
	crossPanSig0 = Pan2.ar(in[0], pos:Select.kr(panSel, [Line.kr(-1, 1, lineDur), {Rand(-1.0, 1.0)}]));
	crossPanSig1 = Pan2.ar(in[1], pos:Select.kr(panSel, [Line.kr(-1, 1, lineDur), {Rand(-1.0, 1.0)}]));

	Out.ar({IRand(~params[\forestOut], (~params[\forestOut]+~params[\forestOutputChannels])-1)}, crossPanSig0[0] );
	Out.ar({IRand(~params[\forestOut], (~params[\forestOut]+~params[\forestOutputChannels])-1)}, crossPanSig0[1] );
	Out.ar({IRand(~params[\forestOut], (~params[\forestOut]+~params[\forestOutputChannels])-1)}, crossPanSig1[0] );
	Out.ar({IRand(~params[\forestOut], (~params[\forestOut]+~params[\forestOutputChannels])-1)}, crossPanSig1[1] );

}).add;


