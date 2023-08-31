(
SynthDef(\spatialLoop, {
	arg buf, out, amp=1, lpfFreq, hpfFreq, lpfOn, hpfOn, masterAmp, gate, panFreq=3, panSel=0;
	var sig, env, pan, onsets;

	sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf), 1, 0, 1, 2);
	onsets = Onsets.kr(FFT(LocalBuf(512), HPF.ar(sig, 80)));

	sig = Select.ar(lpfOn.lag(0.005), [sig, LPF.ar(sig, lpfFreq.lag(0.005))]);
	sig = Select.ar(hpfOn.lag(0.005), [sig, HPF.ar(sig, hpfFreq.lag(0.005))]);

	env = EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = sig * amp * masterAmp * env;


	pan = Select.kr(panSel,
		[
			LFNoise1.kr(panFreq).range(0, 1),
			LFBrownNoise1.kr(panFreq, 0.2).range(0, 1),
			LFBrownNoise1.kr(panFreq, 0.4).range(0, 1),
			LFBrownNoise1.kr(panFreq, 0.6).range(0, 1),
			LFBrownNoise1.kr(panFreq, 0.8).range(0, 1),
			LFBrownNoise1.kr(panFreq, 1.0).range(0, 1),
			TBrownRand.kr(0.0, 1.0, 0.2, 0, onsets),
			TBrownRand.kr(0.0, 1.0, 0.4, 0, onsets),
			TBrownRand.kr(0.0, 1.0, 0.6, 0, onsets),
			TBrownRand.kr(0.0, 1.0, 0.8, 0, onsets),
			TBrownRand.kr(0.0, 1.0, 1.0, 0, onsets),
		]
	);

	sig = PanX.ar(~params[\spatialOutputChannels], sig, pan);

	Out.ar(out, sig);
}).add;
);




