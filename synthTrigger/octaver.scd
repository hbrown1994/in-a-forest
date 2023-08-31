(
~fxSynths.add(\octaver ->
	Synth(\octaver, [
		\gate, 1, \amp, ~params[\octaver][\amp], \masterAmp, ~masterAmp,
		\out, ~params[\mainOut],
		\in0, ~busses[~sendSynthNames[0]],
		\in1, ~busses[~sendSynthNames[1]],
		\in2, ~busses[~sendSynthNames[2]],
		\in3, ~busses[~sendSynthNames[3]],
		\in4, ~busses[~sendSynthNames[4]],
		\numOctaves, ~params[\octaver][\numOctaves],
		\hpf, ~params[\octaver][\hpf], \lpf, ~params[\octaver][\lpf],
	], ~nodes[\fx]).register;
);
);
