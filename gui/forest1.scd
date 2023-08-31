{
	var window;
	var params = [\amp, \trigRate, \posLow, \posHigh, \rateLow, \rateHigh, \durLow, \durHigh, \pan, \sizeLow, \sizeHigh, \hpf, \lpf, \atkLow, \atkHigh, \relLow, \relHigh];
	var paramsMin =  [0, 0.1, 0, 0,  0.1,  0.1, 0.0001, 0.0001, 0,  0.001, 0.001, 20,   6000, 0.001, 0.001, 0.001, 0.001];
	var paramsMax = [1, 40,  1, 1,  10,  10,  4,           4,          1,  3,        3,        300, 20000, 5, 5, 5, 5];
	var horizShift =70;

	~forest1Gui = Dictionary.newFrom([
		\paramSlider, Dictionary.new, \paramNumbox, Dictionary.new

	]);

	~forest1Gui.add(\window -> window = Window.new("forest1", Rect(200.rand, 200.rand, 1350, 480)).front);

	~forest1Gui[\window].background = Color.new255(139,112,88);


	~forest1Gui.add(\onOff -> Button(~forest1Gui[\window], Rect(5, 3, 60, 50))
		.states_([["On", Color.black, Color.green], ["Off", Color.black, Color.red]])
		.action_({arg view; if(view.value==1,
			{
				if(~forestSynths[\forest1].isPlaying, {nil}, {thisProcess.interpreter.executeFile(~path[\synthTrigger]++"forest1.scd")});
			},
			{
				if(~forestSynths[\forest1].isPlaying, {~forestSynths[\forest1].free});
			}
		)});
	);



	params[0..7].do{|i, j|

		StaticText(~forest1Gui[\window], Rect(5+horizShift, 18+(53*j), 60, 20)).string = i.asString;

		if(i==\amp,
			{
				~forest1Gui[\paramSlider].add(i->
					Slider(~forest1Gui[\window], Rect(60+horizShift, 3+(53*j), 500, 50))
					.value_(~params[\forest1][i].linlin(paramsMin[j], paramsMax[j], 0.0, 1.0))
					.action_({arg val;
						val = val.value.linlin(0.0, 1.0, paramsMin[j], paramsMax[j]);
						~params[\forest1][i] = val;
						if(~forestSynths[\forest1].isPlaying, {~forestSynths[\forest1].set(i, val)});
						~forest1Gui[\paramNumbox][i].value = val.ampdb;
					});
				);

				~forest1Gui[\paramNumbox].add(i->
					NumberBox(~forest1Gui[\window], Rect(560+horizShift, 3+(53*j), 50, 50))
					.value_(~params[\forest1][i].ampdb)
					.action_({arg val;
						val = val.value.dbamp;
						~params[\forest1][i] = val;
						if(~forestSynths[\forest1].isPlaying, {~forestSynths[\forest1].set(i, val)});
						~forest1Gui[\paramSlider][i].value = val.value.linlin(paramsMin[j], paramsMax[j], 0.0, 1.0);

					});
				);

			},
			{
				~forest1Gui[\paramSlider].add(i->
					Slider(~forest1Gui[\window], Rect(60+horizShift, 3+(53*j), 500, 50))
					.value_(~params[\forest1][i].linlin(paramsMin[j], paramsMax[j], 0.0, 1.0))
					.action_({arg val;
						val = val.value.linlin(0.0, 1.0, paramsMin[j], paramsMax[j]);
						~params[\forest1][i] = val;
						if(~forestSynths[\forest1].isPlaying, {~forestSynths[\forest1].set(i, val)});
						~forest1Gui[\paramNumbox][i].value = val;
					});
				);

				~forest1Gui[\paramNumbox].add(i->
					NumberBox(~forest1Gui[\window], Rect(560+horizShift, 3+(53*j), 65, 50))
					.value_(~params[\forest1][i])
					.decimals_(4)
					.action_({arg val;
						val = val.value;
						~params[\forest1][i] = val;
						if(~forestSynths[\forest1].isPlaying, {~forestSynths[\forest1].set(i, val)});
						~forest1Gui[\paramSlider][i].value = val.value.linlin(paramsMin[j], paramsMax[j], 0.0, 1.0);

					});
				);

			}
		);
	};


	params[8..17].do{|i, j|
		var horizShiftRight = 700;
		var paramsIndex;
		paramsIndex = j + 8;

		StaticText(~forest1Gui[\window], Rect(5+horizShiftRight, 18+(53*j), 60, 20)).string = i.asString;

		if(i==\amp,
			{
				~forest1Gui[\paramSlider].add(i->
					Slider(~forest1Gui[\window], Rect(60+horizShiftRight, 3+(53*j), 500, 50))
					.value_(~params[\forest1][i].linlin(paramsMin[paramsIndex], paramsMax[paramsIndex], 0.0, 1.0))
					.action_({arg val;
						val = val.value.linlin(0.0, 1.0, paramsMin[paramsIndex], paramsMax[paramsIndex]);
						~params[\forest1][i] = val;
						if(~forestSynths[\forest1].isPlaying, {~forestSynths[\forest1].set(i, val)});
						~forest1Gui[\paramNumbox][i].value = val.ampdb;
					});
				);

				~forest1Gui[\paramNumbox].add(i->
					NumberBox(~forest1Gui[\window], Rect(560+horizShiftRight, 3+(53*j), 50, 50))
					.value_(~params[\forest1][i].ampdb)
					.action_({arg val;
						val = val.value.dbamp;
						~params[\forest1][i] = val;
						if(~forestSynths[\forest1].isPlaying, {~forestSynths[\forest1].set(i, val)});
						~forest1Gui[\paramSlider][i].value = val.value.linlin(paramsMin[paramsIndex], paramsMax[paramsIndex], 0.0, 1.0);

					});
				);

			},
			{
				~forest1Gui[\paramSlider].add(i->
					Slider(~forest1Gui[\window], Rect(60+horizShiftRight, 3+(53*j), 500, 50))
					.value_(~params[\forest1][i].linlin(paramsMin[paramsIndex], paramsMax[paramsIndex], 0.0, 1.0))
					.action_({arg val;
						val = val.value.linlin(0.0, 1.0, paramsMin[paramsIndex], paramsMax[paramsIndex]);
						~params[\forest1][i] = val;
						if(~forestSynths[\forest1].isPlaying, {~forestSynths[\forest1].set(i, val)});
						~forest1Gui[\paramNumbox][i].value = val;
					});
				);

				~forest1Gui[\paramNumbox].add(i->
					NumberBox(~forest1Gui[\window], Rect(560+horizShiftRight, 3+(53*j), 65, 50))
					.value_(~params[\forest1][i])
					.decimals_(4)
					.action_({arg val;
						val = val.value;
						~params[\forest1][i] = val;
						if(~forestSynths[\forest1].isPlaying, {~forestSynths[\forest1].set(i, val)});
						~forest1Gui[\paramSlider][i].value = val.value.linlin(paramsMin[paramsIndex], paramsMax[paramsIndex], 0.0, 1.0);

					});
				);

			}
		);
	};
}.value;