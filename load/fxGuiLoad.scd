{
	var fxNames = ["bitCrusher", "harmonizer",  "reverb", "octaver", "convolution"];

	var fxParams = Dictionary.newFrom([
		\bitCrusher, [\hpf, \lpf, \sampleRate, \bitDepth],
		\harmonizer, [\hpf, \lpf, \numVoices, \ratio0, \ratio1, \ratio2, \ratio3],
		\octaver, [\hpf, \lpf, \numOctaves],
		\reverb, [\hpf, \lpf, \dampFreqLow, \dampFreqHigh, \combDelayLow, \combDelayHigh, \combDecay, \delayLow, \delayHigh, \decayTime, \predelay],
		\convolution, [\hpf, \lpf, \bitDepthHigh, \bitDepthLow],
	]);

	var fxParamsMin = Dictionary.newFrom([
		\bitCrusher, [20, 4000, 10, 1],
		\harmonizer, [20, 4000, 0, -24, -24, -24, -24],
		\octaver, [20, 4000, 0],
		\reverb, [20, 4000, 1000, 1000, 0.001, 0.001, 0, 0.001, 0.001, 0, 0],
		\convolution, [20, 4000, 1, 1],
	]);

	var fxParamsMax = Dictionary.newFrom([
		\bitCrusher, [200, 20000, 44100, 16],
		\harmonizer, [200, 20000, 3, 24, 24, 24, 24],
		\octaver, [200, 20000, 1],
		\reverb, [200, 20000, 20000, 20000, 0.1, 0.1, 10, 0.1, 0.1, 10, 0.5],
		\convolution, [200, 20000, 16, 16]
	]);


	var receives =  Dictionary.newFrom([\flute, \receive0, \clarinet, \receive1, \violin, \receive2, \perc, \receive3, \vox, \receive4]);


	fxNames.do{|fxName|

		~fxGui[\onOff][fxName.asSymbol].value = 0;

		~fxGui[\amp][fxName.asSymbol].value = ~params[fxName.asSymbol][\amp];
		~fxGui[\ampNumbox][fxName.asSymbol].value = ~params[fxName.asSymbol][\amp].ampdb;

		~fxGui[\onOff][fxName.asSymbol].valueAction = 0;

		if(fxName=="convolution", {nil}, {
			receives.keysDo{|i|
				~fxGui[("receiveSliders"++fxName).asSymbol][i].value = ~params[fxName.asSymbol][receives[i]];
				~fxGui[("receiveNumbox"++fxName).asSymbol][i].value = ~params[fxName.asSymbol][receives[i]].ampdb;
			};
		});

		fxParams[fxName.asSymbol].do{|param, index|
		~fxGui[("paramSliders"++fxName).asSymbol][param].value = ~params[fxName.asSymbol][param].linlin(fxParamsMin[fxName.asSymbol][index], fxParamsMax[fxName.asSymbol][index], 0, 1);
		~fxGui[("paramNumbox"++fxName).asSymbol][param].value = ~params[fxName.asSymbol][param];
		};
	};
}.value;






