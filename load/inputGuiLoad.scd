{
	var inputGuiNames = [
		\in1, \in2, \out,
	];

	var inputGuiNamesPerc = [
		\in1, \in2, \in3, \out,
	];


	var filterGuiNames = [
		\lpfOn, \hpfOn, \lpfFreq, \lpfNumbox, \hpfFreq, \hpfNumbox
	];

	5.do{|i|
		if(~inputSynthNames[i]==\inputSynth3, {nil}, {
			if(~params[~inputSynthNames[i]][\stereoMono]==\input, {~inputGui[\stereoMono][i].value=0}, {~inputGui[\stereoMono][i].value=1});
		});

		~dryGui[\amp][i].value = ~params[~inputSynthNames[i]][\amp];
		~dryGui[\ampNumbox][i].value = ~params[~inputSynthNames[i]][\amp].ampdb;

		~sendGui[\amp][i].value = ~params[~sendSynthNames[i]][\amp];
		~sendGui[\ampNumbox][i].value = ~params[~sendSynthNames[i]][\amp].ampdb;

		~dryGui[\pan][i].value = ~params[~inputSynthNames[i]][\pan].linlin(-1.0, 1.0, 0.0, 1.0);
		~dryGui[\panNumbox][i].value = ~params[~inputSynthNames[i]][\pan];

		~sendGui[\pan][i].value = ~params[~sendSynthNames[i]][\pan].linlin(-1.0, 1.0, 0.0, 1.0);
		~sendGui[\panNumbox][i].value = ~params[~sendSynthNames[i]][\pan];

		//FILTERS////
		~dryGui[\lpfOn][i].value = ~params[~inputSynthNames[i]][\lpfOn];
		~dryGui[\hpfOn][i].value = ~params[~inputSynthNames[i]][\hpfOn];


		~dryGui[\lpfFreq][i].value = ~params[~inputSynthNames[i]][\lpfFreq].linlin(8000, 20000, 0.0, 1.0);
		~dryGui[\lpfNumbox][i].value = ~params[~inputSynthNames[i]][\lpfFreq];

		~dryGui[\hpfFreq][i].value = ~params[~inputSynthNames[i]][\hpfFreq].linlin(20, 200, 0.0, 1.0);
		~dryGui[\hpfNumbox][i].value = ~params[~inputSynthNames[i]][\hpfFreq];

	};

	~inputSynthNames.do{|i, j|
		if(i==\inputSynth3,
			{

				inputGuiNames.do{|k|
					~inputGui[k][j].value = ~params[i][k].asString;

				};
				~inputGui[\in3][0].value = ~params[\inputSynth3][\in3];

			},
			{
				inputGuiNames.do{|k|
					~inputGui[k][j].value = ~params[i][k].asString;

				};
			}
		);
	};
}.value;
