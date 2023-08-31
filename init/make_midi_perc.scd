(
MIDIIn.connectAll;

{
	var glitchNums=Array.series(5, 48), oneshotNums=[64, 67], holdNums=[65, 66], spatialNums = [32, 33, 34];
	var octaverNums=#[46, 58, 58];
	var fxNums=#[0, 25, 26];
	var holdSynths = Array.newClear(2);
	var spatialSynths = Array.newClear(3);
	var oneshotSynths = Array.newClear(10);


	//forests
	[38, 39].do{|i, j|
		var name = [\forest0, \forest1];

		MIDIFunc.noteOn({
			if(~forestSynths[name[j]].isPlaying, {nil}, 	{thisProcess.interpreter.executeFile(~path[\synthTrigger]++name[j].asString++".scd")});
		}, i, 2);

		MIDIFunc.noteOff({
			if(~forestSynths[name[j]].isPlaying, {~forestSynths[name[j]].free});
		}, i, 2);

	};

	//spatialLoops
	spatialNums.do{|i, j|
		var thisSample = ~buffersNames[\spatial][j].asSymbol;

		MIDIFunc.noteOn({
			if(spatialSynths[j].isPlaying, {nil}, {
				spatialSynths[j] = Synth(\spatialLoop, [\gate, 1,
					\buf, ~buffers[\spatial][j],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
					\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
					\panFreq, ~params[thisSample][\panFreq], \panSel, ~params[thisSample][\panSel],
				], ~nodes[\fixed]).register;
			});
		}, i, 2);

		MIDIFunc.noteOff({
			if(spatialSynths[j].isPlaying, {spatialSynths[j].set(\gate, 0)});
		}, i, 2);
	};

	//LOUD
	MIDIFunc.cc({arg msg;
		var thisSample=~buffersNames[\percussion][9].asSymbol;
		var sampleNum = 9;
		if(msg==127,
			{
				if(oneshotSynths[sampleNum].isPlaying, {oneshotSynths[sampleNum].set(\t_trig, 1)}, {
					oneshotSynths[sampleNum] = Synth(\oneShot, [\t_trig, 1,
						\buf, ~buffers[\percussion][9],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
						\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
						\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
						\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
					], ~nodes[\fixed]).register;
				});
		});
	}, 64, 0);

	//NANOKNTROL 0-4 (glitches)
	glitchNums.do{|i, j|
		var thisSample = ~buffersNames[\percussion][j].asSymbol;

		MIDIFunc.noteOn({
			if(oneshotSynths[j].isPlaying, {oneshotSynths[j].set(\t_trig, 1)}, {
				oneshotSynths[j] = Synth(\oneShot, [\t_trig, 1,
					\buf, ~buffers[\percussion][j],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
					\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
					\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
					\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
				], ~nodes[\fixed]).register;
			});
		}, i, 2);
	};

	//NANOKNTROL 5 and 8 (snare/kick)
	oneshotNums.do{|i, j|
		var sampleNum=[5, 8][j];
		var thisSample = ~buffersNames[\percussion][sampleNum].asSymbol;

		MIDIFunc.noteOn({
			if(oneshotSynths[sampleNum].isPlaying, {oneshotSynths[sampleNum].set(\t_trig, 1)}, {
				oneshotSynths[sampleNum] = Synth(\oneShot, [\t_trig, 1,
					\buf, ~buffers[\percussion][sampleNum],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
					\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
					\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
					\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
				], ~nodes[\fixed]).register;
			});
		}, i, 2);
	};

	//HOLD SYNTHS 6 and 7 (snare/kick)
	holdNums.do{|i, j|
		var sampleNum=[6, 7][j];
		var thisSample = ~buffersNames[\percussion][sampleNum].asSymbol;

		MIDIFunc.noteOn({
			if(holdSynths[j].isPlaying, {nil}, {
				holdSynths[j] = Synth(\loop, [\gate, 1,
					\buf, ~buffers[\percussion][sampleNum],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
					\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
					\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
					\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
				], ~nodes[\fixed]).register;
			});
		}, i, 2);

		MIDIFunc.noteOff({
			if(holdSynths[j].isPlaying, {holdSynths[j].set(\gate, 0)});
		}, i, 2);
	};


	//octaver
	MIDIFunc.noteOn({
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
	}, 27, 2);

	MIDIFunc.noteOff({
		if(~fxSynths[\octaver].isPlaying, {~fxSynths[\octaver].set(\gate, 0)});
	}, 27, 2);

	MIDIFunc.noteOn({
		~params[\octaver][\numOctaves] = 0;
		if(~fxSynths[\octaver].isPlaying, {~fxSynths[\octaver].set(\numOctaves, 0)});
	}, 61, 2);

	MIDIFunc.noteOn({
		~params[\octaver][\numOctaves] = 1;
		if(~fxSynths[\octaver].isPlaying, {~fxSynths[\octaver].set(\numOctaves, 1)});
	}, 62, 2);


	//other fx
	fxNums.do{|i, j|
		var fxName=[\bitCrusher, \harmonizer, \reverb][j];

		MIDIFunc.noteOn({
			if(~fxSynths[fxName].isPlaying, {nil}, {thisProcess.interpreter.executeFile(~path[\synthTrigger]++fxName.asString++".scd")});
		}, i, 2);

		MIDIFunc.noteOff({
			if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(\gate, 0)});
		}, i, 2);
	};
}.value;
);
