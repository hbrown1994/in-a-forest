~inputSynthNames.do{|i|
	if(i==\inputSynth3,
		{
			~inputSynths.add(
				Synth(\inputTriple, [
					\in1, ~params[i][\in1], \in2,~params[i][\in2], \in3,~params[i][\in3],
					\lpfOn, ~params[i][\lpfOn], \hpfOn, ~params[i][\hpfOn],
					\lpfFreq, ~params[i][\lpfFreq], \hpfFreq, ~params[i][\hpfFreq],
					\out, ~params[i][\out], \pan, ~params[i][\pan], \amp, ~params[i][\amp],
					\masterAmp, ~masterAmp

				], ~nodes[\input]).register;
			);
		},
		{
			~inputSynths.add(
				Synth(~params[i][\stereoMono], [
					\in1, ~params[i][\in1], \in2,~params[i][\in2],
					\lpfOn, ~params[i][\lpfOn], \hpfOn, ~params[i][\hpfOn],
					\lpfFreq, ~params[i][\lpfFreq], \hpfFreq, ~params[i][\hpfFreq],
					\out, ~params[i][\out], \pan, ~params[i][\pan], \amp, ~params[i][\amp],
					\masterAmp, ~masterAmp
				], ~nodes[\input]).register;
			);
		}
	)

};

~sendSynthNames.do{|i|
	if(i==\sendSynth3,
		{
			~sendSynths.add(
				Synth(\inputTriple, [
					\in1, ~params[i][\in1], \in2,~params[i][\in2], \in3,~params[i][\in3],
					\lpfOn, ~params[i][\lpfOn], \hpfOn, ~params[i][\hpfOn],
					\lpfFreq, ~params[i][\lpfFreq], \hpfFreq, ~params[i][\hpfFreq],
					\out, ~busses[i], \pan, ~params[i][\pan], \amp, ~params[i][\amp],
					\masterAmp, 1
				], ~nodes[\sends]).register;
			);
		},
		{
			~sendSynths.add(
				Synth(~params[i][\stereoMono], [
					\in1, ~params[i][\in1], \in2,~params[i][\in2],
					\lpfOn, ~params[i][\lpfOn], \hpfOn, ~params[i][\hpfOn],
					\lpfFreq, ~params[i][\lpfFreq], \hpfFreq, ~params[i][\hpfFreq],
					\out, ~busses[i], \pan, ~params[i][\pan], \amp, ~params[i][\amp],
					\masterAmp, 1
				], ~nodes[\sends]).register;
			);

		}
	);
};
