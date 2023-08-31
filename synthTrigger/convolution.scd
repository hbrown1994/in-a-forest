(
~fxSynths.add(\convolution ->
	Synth(\convolution, [
		\gate, 1, \amp, ~params[\convolution][\amp], \masterAmp, ~masterAmp,
		\out, ~params[\mainOut],
		\in0,  ~busses[~sendSynthNames[4]],
		\hpf, ~params[\convolution][\hpf], \lpf, ~params[\convolution][\lpf],
		\bitDepthHigh, ~params[\convolution][\bitDepthHigh], \bitDepthLow, ~params[\convolution][\bitDepthLow]
	], ~nodes[\fx]).register;
);
);