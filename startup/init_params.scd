Routine{
	~params = Dictionary.newFrom([\forestOut, 2, \forestOutputChannels, 6, \mainOut, 0, \spatialOut, 0, \spatialOutputChannels, 8]);

	0.005.wait;

	(~inputSynthNames).do{|i, j|

		if(i==\inputSynth3,
			{
				~params.add(i -> Dictionary.newFrom([\stereoMono, \inputTriple, \in1, j, \in2, j+5, \in3, j+10, \lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \pan, 0,  \amp, 0, \out, ~params[\mainOut]]));
			},
			{
				~params.add(i -> Dictionary.newFrom([\stereoMono, \input, \in1, j, \in2, j+5, \lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \pan, 0,  \amp, 0, \out, ~params[\mainOut]]));
			}
		);

	};


	(~sendSynthNames).do{|i, j|
		if(i==\inputSynth3,
			{
				~params.add(i -> Dictionary.newFrom([\stereoMono, \inputTriple, \in1, j, \in2, j+5, \in3, j+10, \lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \pan, 0, \amp, 0]));
			},
			{
				~params.add(i -> Dictionary.newFrom([\stereoMono, \input, \in1, j, \in2, j+5, \lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \pan, 0, \amp, 0]));
			}
		);
	};

	//__________________FX__________________
	~params.add(\bitCrusher -> Dictionary.newFrom([\amp, 0, \hpf, 20, \lpf, 20000, \sampleRate, 44100, \bitDepth, 16, \out, ~params[\mainOut], \receive0, 1, \receive1, 1, \receive2, 1, \receive3, 1, \receive4, 0]));

	~params.add(\harmonizer -> Dictionary.newFrom(
		[
			\amp, 0, \hpf, 20, \lpf, 20000, \numVoices, 0, \out, ~params[\mainOut],
			\ratio0, 0,  \ratio1, 0,  \ratio2, 0,  \ratio3, 0,
			\receive0, 1, \receive1, 1, \receive2, 1, \receive3, 1, \receive4, 0
		]
	));

	~params.add(\octaver -> Dictionary.newFrom([\amp, 0, \hpf, 20, \lpf, 20000, \out, ~params[\mainOut], \numOctaves, 0, \receive0, 1, \receive1, 1, \receive2, 1, \receive3, 1, \receive4, 0]));

	~params.add(\reverb -> Dictionary.newFrom([\amp, 0, \hpf, 20, \lpf, 20000, \out, ~params[\mainOut], \dampFreqLow, 12000, \dampFreqHigh, 18000, \combDelayLow, 0.02, \combDelayHigh, 0.07, \combDecay, 0.7, \delayLow, 0.01, \delayHigh, 0.05, \decayTime, 1, \predelay, 0.048, \hpf, 100, \receive0, 1, \receive1, 1, \receive2, 1, \receive3, 1, \receive4, 0]));

	~params.add(\convolution -> Dictionary.newFrom([\amp, 0, \hpf, 20, \lpf, 20000, \bitDepthHigh, 16, \bitDepthLow, 8, \out, ~params[\mainOut]]));


	~buffersNames[\percussion].do{|i|
		i=i.asSymbol;
		~params.add(i -> Dictionary.newFrom(
			[
				\lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \amp, 1, \out, ~params[\mainOut],
				\route0, 1, \route1, 1, \route2, 0, \route3, 0, \route4, 0, \route5, 0, \route6, 0, \route7, 0
			]
		));
	};

	~buffersNames[\spatial].do{|i|
		i=i.asSymbol;
		~params.add(i -> Dictionary.newFrom(
			[
				\lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \amp, 1, \out, ~params[\spatialOut],
				\panFreq, 1, \panSel, 0

			]
		));
	};


	~buffersNames[\vox].do{|i|
		i=i.asSymbol;
		~params.add(i -> Dictionary.newFrom(
			[
				\lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \amp, 1, \out, ~params[\mainOut],
				\route0, 1, \route1, 1, \route2, 0, \route3, 0, \route4, 0, \route5, 0, \route6, 0, \route7, 0
			]
		));
	};


	[367.0, 366.5, 383.7, 324.3].do{|i|
		i=i.asSymbol;
		~params.add(i -> Dictionary.newFrom(
			[
				\pan, 0, \amp, 1, \out, ~params[\mainOut],
				\route0, 1, \route1, 1, \route2, 0, \route3, 0, \route4, 0, \route5, 0, \route6, 0, \route7, 0
			]
		));
	};

	//forests
	~params.add(\forest0 -> Dictionary.newFrom(
		[
			\amp, 0.4, \hpf, 20, \lpf, 20000, \out, ~params[\forestOut],
			\trigRate, 18,
			\posLow, 0, \posHigh, 1,
			\rateLow, 1, \rateHigh, 1,
			\durLow, 0.1, \durHigh, 0.5,
			\pan, 0,
			\sizeLow, 0.1, \sizeHigh, 0.2,
			\atkLow, 0.005, \atkHigh, 0.005,
			\relLow, 0.005, \relHigh, 0.005,
		]
	));

	~params.add(\forest1 -> Dictionary.newFrom(
		[
			\amp, 0.4, \hpf, 20, \lpf, 20000, \out, ~params[\forestOut],
			\trigRate, 18,
			\posLow, 0, \posHigh, 1,
			\rateLow, 1, \rateHigh, 1,
			\durLow, 0.1, \durHigh, 0.5,
			\pan, 0,
			\sizeLow, 0.1, \sizeHigh, 0.2,
			\atkLow, 0.005, \atkHigh, 0.005,
			\relLow, 0.005, \relHigh, 0.005,
		]
	));


	"Parameters Loaded".postln;

}.play(AppClock);


