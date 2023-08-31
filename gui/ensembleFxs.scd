{
	var  window, comp=List.new, fxNames = [\bitCrusher, \harmonizer, \reverb, \octaver, \convolution];

	var fxParams = Dictionary.newFrom([
		\bitCrusher, [\hpf, \lpf, \sampleRate, \bitDepth],
		\harmonizer, [\hpf, \lpf, \numVoices, \ratio0, \ratio1, \ratio2, \ratio3],
		\octaver, [\hpf, \lpf, \numOctaves],
		\reverb, [\hpf, \lpf, \dampFreqLow, \dampFreqHigh, \combDelayLow, \combDelayHigh, \combDecay, \delayLow, \delayHigh, \decayTime, \predelay],
		\convolution, [\hpf, \lpf, \bitDepthHigh, \bitDepthLow]

	]);

	var fxParamsMin = Dictionary.newFrom([
		\bitCrusher, [20, 4000, 10, 1],
		\harmonizer, [20, 4000, 0, -24, -24, -24, -24],
		\octaver, [20, 4000, 0],
		\reverb, [20, 4000, 1000, 1000, 0.001, 0.001, 0, 0.001, 0.001, 0, 0],
		\convolution, [20, 4000, 1, 1]
	]);

	var fxParamsMax = Dictionary.newFrom([
		\bitCrusher, [200, 20000, 44100, 16],
		\harmonizer, [200, 20000, 3, 24, 24, 24, 24],
		\octaver, [200, 20000, 1],
		\reverb, [200, 20000, 20000, 20000, 0.1, 0.1, 10, 0.1, 0.1, 10, 0.5],
		\convolution, [200, 20000, 16, 16]
	]);

	~fxGui = Dictionary.newFrom([
		\fxNames, ["Bit Crusher", "Harmonizer", "Reverb", "Octaver", "Convolution"],	\onOff, Dictionary.new, \receivesOpen, Dictionary.new, \params, Dictionary.new, \amp, Dictionary.new, \ampNumbox,Dictionary.new,
		\receiveWindows, Dictionary.new,
		\receiveSlidersbitCrusher, Dictionary.new, \receiveNumboxbitCrusher, Dictionary.new,
		\receiveSlidersharmonizer, Dictionary.new, \receiveNumboxharmonizer, Dictionary.new,
		\receiveSlidersoctaver, Dictionary.new, \receiveNumboxoctaver, Dictionary.new,
		\receiveSlidersreverb, Dictionary.new, \receiveNumboxreverb, Dictionary.new,
		\paramWindows, Dictionary.new,
		\paramSlidersbitCrusher, Dictionary.new, \paramNumboxbitCrusher, Dictionary.new,
		\paramSlidersharmonizer, Dictionary.new, \paramNumboxharmonizer, Dictionary.new,
		\paramSlidersoctaver, Dictionary.new, \paramNumboxoctaver, Dictionary.new,
		\paramSlidersreverb, Dictionary.new, \paramNumboxreverb, Dictionary.new,
		\paramSlidersconvolution, Dictionary.new, \paramNumboxconvolution, Dictionary.new,
	]);



	window = Window.new("FXs", Rect(420, 600, 800, 500)).front;
	window.view.decorator = FlowLayout( window.view.bounds, 0@0, 0@0 );

	5.do{|i| comp.add(CompositeView( window.view, 160@500 ).background_( [Color.yellow(1.0), Color.cyan(1.0), Color.yellow(1.0), Color.cyan(1.0), Color.magenta][i] )) };

	comp.do{|i, j|
		var f, inputText=[60, 80, 65, 55, 50], fxName;
		f = StaticText(i, Rect(5, 5, 100, 20)).string = ~fxGui[\fxNames][j];
		f.font = Font("Helvetica", 18);
		fxName = [\bitCrusher, \harmonizer, \reverb, \octaver, \convolution][j];

		//stereo on/pff
		~fxGui[\onOff].add(fxName -> Button(i, Rect(90, 30, 60, 50))
			.states_([["Off", Color.black, Color.red], ["On", Color.black, Color.green]])
			.action_({arg view; if(view.value==1,
				{
					if(~fxSynths[fxName].isPlaying, {nil}, {thisProcess.interpreter.executeFile(~path[\synthTrigger]++fxName.asString++".scd")});
				},
				{
					if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(\gate, 0)});
				}
			)});
		);



		//outputSlider
		~fxGui[\amp].add(fxName ->
			Slider(i, Rect(10, 170, 90, 300))
			.value_(0)
			.action_({arg val;
				val = val.value;
				~params[fxName][\amp] = val;
				if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(\amp, val)});
				~fxGui[\ampNumbox][fxName].value_(val.ampdb);
			});
		);


		//~dryGui[\ampNumbox]
		~fxGui[\ampNumbox].add(fxName ->
			NumberBox(i, Rect(10, 470, 90, 20))
			.value_(-inf)
			.action_({arg val; ~fxGui[\amp][fxName].valueAction_(val.value.dbamp)});
		);



		/*_____________Receives______________________________________________*/

		if(fxName!=\convolution, {

			~fxGui[\receiveWindows].add(fxName ->
				Window.new("Receives: "++fxName.asString, Rect(30+100, 100, 630, 270)).visible=false
			);

			~fxGui[\receivesOpen].add(fxName -> Button(i, Rect(10, 90, 60, 50))
				.states_([["Receives", Color.black, Color.magenta], ["Close", Color.black, Color.grey]])
				.action_({arg view; if(view.value==1,
					{
						~fxGui[\receiveWindows][fxName].visible=true;
					},
					{
						~fxGui[\receiveWindows][fxName].visible=false;
					}
				)});
			);


			~instrumentNames.do{|name, index|
				var paramName = [\receive0, \receive1, \receive2, \receive3, \receive4][index];
				var thisFxName = fxName.asString;
				~fxGui[("receiveSliders"++thisFxName).asSymbol].add(name.toLower.asSymbol ->
					Slider(~fxGui[\receiveWindows][fxName], Rect(53, 3+(53*index), 500, 50))
					.value_([1, 1, 1, 1, 0][index])
					.action_({arg val;
						val = val.value;
						~params[fxName][paramName] = val;
						if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(paramName, val)});
						~fxGui[("receiveNumbox"++thisFxName).asSymbol][name.toLower.asSymbol].value = val.ampdb;
					});
				);


				StaticText(~fxGui[\receiveWindows][fxName], Rect(5, 18+(53*index), 35, 20)).string = name;

				~fxGui[("receiveNumbox"++thisFxName).asSymbol].add(name.toLower.asSymbol  ->
					NumberBox(~fxGui[\receiveWindows][fxName], Rect(570, 3+(53*index), 50, 50))
					.value_([0, 0, 0, 0, -inf][index])
					.action_({arg val;
						~fxGui[("receiveSliders"++thisFxName).asSymbol][name.toLower.asSymbol].valueAction=val.value.dbamp;
					});
				);
			};
		});



		/*_____________Params______________________________________________*/
		~fxGui[\paramWindows].add(fxName ->
			Window.new("Params: "++fxName.asString, Rect(30+100, 100, 710, [220, 380, 590, 160, 220][j])).visible=false
		);

		~fxGui[\params].add(fxName ->Button(i, Rect(10, 30, 60, 50))
			.states_([["Params", Color.black, Color.white], ["Close", Color.black, Color.grey]])
			.action_({arg view; if(view.value==1,
				{
					~fxGui[\paramWindows][fxName].visible=true;
				},
				{
					~fxGui[\paramWindows][fxName].visible=false;
				}
			)});
		);


		fxParams[fxName].do{|paramName, index|
			var thisFxName = fxName.asString;

			StaticText(~fxGui[\paramWindows][fxName], Rect(5, 18+(53*index), 100, 20)).string = paramName.asString;

			~fxGui[("paramSliders"++thisFxName).asSymbol].add(paramName ->
				Slider(~fxGui[\paramWindows][fxName], Rect(110, 3+(53*index), 535, 50))
				.value_(~params[fxName][paramName].linlin(fxParamsMin[fxName][index], fxParamsMax[fxName][index], 0, 1))
				.action_({arg val;
					val = val.value.linlin(0, 1, fxParamsMin[fxName][index], fxParamsMax[fxName][index]);
					~params[fxName][paramName]=val;
					if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(paramName, val)});
					~fxGui[("paramNumbox"++thisFxName).asSymbol][paramName].value=val;

				});
			);


			~fxGui[("paramNumbox"++thisFxName).asSymbol].add(paramName  ->
				NumberBox(~fxGui[\paramWindows][fxName], Rect(650, 3+(53*index), 50, 50))
				.value_(~params[fxName][paramName])
				.action_({arg val;
					~fxGui[("paramSliders"++thisFxName).asSymbol][paramName].valueAction=val.value.linlin(fxParamsMin[fxName][index], fxParamsMax[fxName][index], 0, 1);
				});
			);
		};
	};
}.value;