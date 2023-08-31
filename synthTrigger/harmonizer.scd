(
~fxSynths.add(\harmonizer ->
	Synth(\harmonizer, [
		\gate, 1, \amp, ~params[\harmonizer][\amp], \masterAmp, ~masterAmp,
		\out, ~params[\mainOut],
		\in0, ~busses[~sendSynthNames[0]],
		\in1, ~busses[~sendSynthNames[1]],
		\in2, ~busses[~sendSynthNames[2]],
		\in3, ~busses[~sendSynthNames[3]],
		\in4, ~busses[~sendSynthNames[4]],
		\numVoices, ~params[\harmonizer][\numVoices],
		\ratio0, ~params[\harmonizer][\ratio0],
		\ratio1, ~params[\harmonizer][\ratio1],
		\ratio2, ~params[\harmonizer][\ratio2],
		\ratio3, ~params[\harmonizer][\ratio3],
		\hpf, ~params[\harmonizer][\hpf], \lpf, ~params[\harmonizer][\lpf],
	], ~nodes[\fx]).register;
);
);