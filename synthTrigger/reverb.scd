(
~fxSynths.add(\reverb ->
	Synth(\reverb, [
		\gate, 1, \amp, ~params[\reverb][\amp], \masterAmp, ~masterAmp,
		\out, ~params[\mainOut],
		\in0, ~busses[~sendSynthNames[0]],
		\in1, ~busses[~sendSynthNames[1]],
		\in2, ~busses[~sendSynthNames[2]],
		\in3, ~busses[~sendSynthNames[3]],
		\in4, ~busses[~sendSynthNames[4]],
		\dampFreqLow, ~params[\reverb][\dampFreqLow], \dampFreqHigh, ~params[\reverb][\dampFreqHigh], \predelay, ~params[\reverb][\predelay],
		\combDelayLow, ~params[\reverb][\combDelayLow], \combDelayHigh, ~params[\reverb][\combDelayHigh], \combDecay, ~params[\reverb][\combDecay],
		\delayLow, ~params[\reverb][\delayLow], \delayHigh, ~params[\reverb][\delayHigh], \decayTime, ~params[\reverb][\decayTime],
		\hpf, ~params[\reverb][\hpf], \lpf, ~params[\reverb][\lpf],
	], ~nodes[\fx]).register;
);
);