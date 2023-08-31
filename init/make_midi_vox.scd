{
	var oneshotSynths = Array.newClear(4);
	var sines = Array.newClear(4);
	var synths = Array.newClear(2);
	var oneshotNums = #[37, 39, 41, 43];
	var holdNums = 45;
	var loopOnNums = #[47, 49];
	var loopOffNums = #[46, 48];
	var holdSynth;
	var sineNums =  #[36, 38, 40, 42];
	var sineFreqs=#[324.3, 366.5, 367.0, 383.7];


	MIDIIn.connectAll;

	//oneshots
	4.do{|i|
		var thisSample = ~buffersNames[\vox][i].asSymbol;

		MIDIFunc.noteOn({arg msg;

			if(oneshotSynths[i].isPlaying, {oneshotSynths[i].set(\t_trig, 1)}, {

				oneshotSynths[i] = Synth(\oneShot, [\t_trig, 1,
					\buf, ~buffers[\vox][i],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
					\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
					\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
					\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
				], ~nodes[\fixed]).register;
			});

		}, oneshotNums[i], 3);
	};

	//loopers
	2.do{|i|
		var add = 5;
		var thisSample = ~buffersNames[\vox][i+add].asSymbol;


		MIDIFunc.noteOn({arg msg;

			if(synths[i].isPlaying, {nil}, {
				synths[i] = Synth(\loop, [\gate, 1,
					\buf, ~buffers[\vox][i+add],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
					\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
					\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
					\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
				], ~nodes[\fixed]).register;
			});

		}, loopOnNums[i], 3);

		MIDIFunc.noteOff({arg msg;

			if(synths[i].isPlaying, {synths[i].set(\gate, 0)});

		}, loopOffNums[i], 3);

	};

	//HOLD SYNTH ("SHOVE")
	MIDIFunc.noteOn({arg msg;
		var thisSample = ~buffersNames[\vox][4].asSymbol;
		if(holdSynth.isPlaying, {nil}, {
			holdSynth= Synth(\loop, [\gate, 1,
				\buf, ~buffers[\vox][4],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
				\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
				\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
				\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
			], ~nodes[\fixed]).register;
		});
	}, 45, 3);

	MIDIFunc.noteOff({arg msg;
		if(holdSynth.isPlaying, {holdSynth.set(\gate, 0)});
	}, 45, 3);

	//CONVOLUTION ON/OFF
	MIDIFunc.noteOn({arg msg;
		if(~fxSynths[\convolution].isPlaying, {nil}, {thisProcess.interpreter.executeFile(~path[\synthTrigger]++"convolution.scd")});
	}, 51, 3);

	MIDIFunc.noteOn({arg msg;
		if(~fxSynths[\convolution].isPlaying, {~fxSynths[\convolution].set(\gate, 0)});
	}, 50, 3);


	//SINE WAVE ON/OFF
	4.do{|i|
		var thisSample = sineFreqs[i].asSymbol;

		MIDIFunc.noteOn({arg msg;

			if(sines[i].isPlaying, {nil}, {
				sines[i] = Synth(\sine, [\gate, 1,
					\pan, ~params[thisSample][\pan], \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp, \freq, sineFreqs[i],
					\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
					\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
				], ~nodes[\fixed]).register;
			});

		}, sineNums[i], 3);

		MIDIFunc.noteOff({arg msg;
			if(sines[i].isPlaying, {sines[i].set(\gate, 0)});
		}, sineNums[i], 3);
	};

}.value;

