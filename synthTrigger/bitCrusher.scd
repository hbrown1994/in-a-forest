~fxSynths.add(\bitCrusher -> Synth(\bitCrusher, [
	\gate, 1, \amp, ~params[\bitCrusher][\amp], \masterAmp, ~masterAmp,
	\out, ~params[\mainOut],
	\in0, ~busses[~sendSynthNames[0]],
	\in1, ~busses[~sendSynthNames[1]],
	\in2, ~busses[~sendSynthNames[2]],
	\in3, ~busses[~sendSynthNames[3]],
	\in4, ~busses[~sendSynthNames[4]],
	\sampleRate, ~params[\bitCrusher][\sampleRate], \bitDepth, ~params[\bitCrusher][\bitDepth],
	\hpf, ~params[\bitCrusher][\hpf], \lpf, ~params[\bitCrusher][\lpf],

], ~nodes[\fx]).register;
);
