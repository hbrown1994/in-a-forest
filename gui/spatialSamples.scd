{
	var window, compositeViews=List.new, sampleNames, numCompositeViews;

	~spatialGui = Dictionary.newFrom([
		\filterWindows, Dictionary.new, \filterButtons, Dictionary.new,
		\amp, Dictionary.new, \ampNumbox, Dictionary.new, \trig, Dictionary.new,
		\lpfOn, Dictionary.new, \lpfFreq, Dictionary.new, \lpfNumbox, Dictionary.new, \hpfOn, Dictionary.new, \hpfFreq, Dictionary.new, \hpfNumbox, Dictionary.new,
		\routeButtons, Dictionary.new, \panSelMenu, Dictionary.new, \panFreqSlider, Dictionary.new, \panFreqNumbox, Dictionary.new
	]);

	numCompositeViews=~buffersNames[\spatial].size;

	window = Window.new("spatial Samples", Rect(200.rand, 200.rand, 660, 530)).front;
	window.view.decorator = FlowLayout( window.view.bounds, 0@0, 0@0 );

	numCompositeViews.do{|i| compositeViews.add(CompositeView( window.view, 220@640 ).background_( Color.red(val: ([0.8, 1.2]!3).flatten[i], alpha: 1.0) )) };

	compositeViews.do{|i, j|
		var f, inputText=[60, 80, 65, 55, 50];
		var thisSample = ~buffersNames[\spatial][j].asSymbol;
		var thisSynth0, thisSynth1;
		var synths =  [nil, nil, nil, nil, nil, thisSynth0, thisSynth1];
		f = StaticText(i, Rect(5, 5, 130, 20)).string = thisSample;
		f.font = Font("Helvetica", 18);

		~spatialGui[\trig].add(thisSample ->
			Button(i, Rect(5, 30, 90, 50))
			.states_([["Loop", Color.black, Color.grey], ["Off", Color.black, Color.red]])
			.action_({arg val;
				if(val.value==1, {
					if(synths[j].isPlaying, {nil}, {
						synths[j] = Synth(\spatialLoop, [\gate, 1,
							\buf, ~buffers[\spatial][j],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
							\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
							\panFreq, ~params[thisSample][\panFreq], \panSel, ~params[thisSample][\panSel],

						], ~nodes[\fixed]).register;
					});
				}, {if(synths[j].isPlaying, {synths[j].set(\gate, 0)})});
			});
		);

		//outputSlider
		StaticText(i, Rect(35, 80, 100, 20)).string = "Out";
		~spatialGui[\amp].add(thisSample ->
			Slider(i, Rect(3, 100, 90, 300))
			.value_(1)
			.action_({arg val;
				~params[thisSample][\amp] = val.value;
				~spatialGui[\ampNumbox][thisSample].value_(val.value.ampdb);
				if(synths[j].isPlaying, {synths[j].set(\amp, val.value)});
			});
		);

		//~spatialGui[\ampNumbox]
		~spatialGui[\ampNumbox].add(thisSample ->
			NumberBox(i, Rect(3, 400, 90, 20))
			.value_(0)
			.action_({arg val; ~spatialGui[\amp][thisSample].valueAction_(val.value.dbamp)});
		);

		//filters
		~spatialGui[\filterWindows].add(thisSample -> Window.new("Filters: "++thisSample.asString, Rect(30, 100, 630, 120)).visible=false);

		~spatialGui[\filterButtons].add(thisSample -> Button(i, Rect(3, 423, 90, 30))
			.states_([["Filters", Color.black, Color.magenta], ["Close", Color.black, Color.red]])
			.action_({arg val; if(val.value==1, {~spatialGui[\filterWindows][thisSample].visible=true}, {~spatialGui[\filterWindows][thisSample].visible=false})});
		);

		//palSel
		~spatialGui[\panSelMenu].add(thisSample ->
			PopUpMenu(i, Rect(10, 460, 500, 50))
			.items_([
				"Random",
				"RandWalk_20%",
				"RandWalk_40%",
				"RandWalk_60%",
				"RandWalk_80%",
				"RandWalk_100%",
				"Onset_RandWalk_20%",
				"Onset_RandWalk_40%",
				"Onset_RandWalk_60%",
				"Onset_RandWalk_80%",
				"Onset_RandWalk_100%",
			])
			.value_(0)
			.action_({arg val;
				~params[thisSample]['panSel']=val.value;
				if(synths[j].isPlaying, {synths[j].set(\panSel, val)});
			});
		);

		{
			var shift = 110;
			//pan freq
			StaticText(i, Rect(20+shift, 80, 100, 20)).string = "Pan Freq";
			~spatialGui[\panFreqSlider].add(thisSample ->
				Slider(i, Rect(3+shift, 100, 90, 300))
				.value_(~panFreqMax)
				.action_({arg val;
					val = val.value.linlin(0.0, 1.0, 0.0, ~panFreqMax);
					~params[thisSample][\panFreq] = val;
					~spatialGui[\panFreqNumbox][thisSample].value_(val);
					if(synths[j].isPlaying, {synths[j].set(\panFreq, val)});
				});
			);

			~spatialGui[\panFreqNumbox].add(thisSample ->
				NumberBox(i, Rect(3+shift, 400, 90, 20))
				.value_(~panFreqMax)
				.action_({arg val; ~spatialGui[\panFreqSlider][thisSample].value_(val.value.linlin(0.0, ~panFreqMax, 0.0, 1.0))});
			);


		}.value;

		//filtersOnOff
		~spatialGui[\lpfOn].add(thisSample ->
			Button(~spatialGui[\filterWindows][thisSample], Rect(3, 3, 60, 50))
			.states_([["LPF", Color.black, Color.green], ["Off", Color.black, Color.red]])
			.action_({arg val;
				val = val.value;
				~params[thisSample][\lpfOn] = val;
				if(synths[j].isPlaying, {synths[j].set(\lpfOn, val)});

			});
		);
		//
		~spatialGui[\hpfOn].add(thisSample ->
			Button(~spatialGui[\filterWindows][thisSample], Rect(3, 60, 60, 50))
			.states_([["HPF", Color.black, Color.magenta], ["Off", Color.black, Color.red]])
			.action_({arg val;
				val = val.value;
				~params[thisSample][\hpfOn] = val;
				if(synths[j].isPlaying, {synths[j].set(\hpfOn, val)});
			});
		);
		//
		~spatialGui[\lpfFreq].add(thisSample ->
			Slider(~spatialGui[\filterWindows][thisSample], Rect(65, 3, 500, 50))
			.value_(1)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 4000, 20000);
				~spatialGui[\lpfNumbox][thisSample].value_(val);
				~params[thisSample][\lpfFreq] = val;
				if(synths[j].isPlaying, {synths[j].set(\lpfFreq, val)});
			});
		);
		//
		~spatialGui[\lpfNumbox].add(thisSample ->
			NumberBox(~spatialGui[\filterWindows][thisSample], Rect(570, 3, 50, 50))
			.value_(20000)
			.action_({arg val;
				val = val.value.linlin(4000, 20000, 0.0, 1.0);
				~spatialGui[\lpfFreq][thisSample].valueAction_(val);
				if(synths[j].isPlaying, {synths[j].set(\lpfFreq, val)});
			});
		);
		//
		~spatialGui[\hpfFreq].add(thisSample ->
			Slider(~spatialGui[\filterWindows][thisSample], Rect(65, 60, 500, 50))
			.value_(0)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 20,  500);
				~spatialGui[\hpfNumbox][thisSample].value_(val);
				~params[thisSample][\hpfFreq] = val;
				if(synths[j].isPlaying, {synths[j].set(\hpfFreq, val)});
			});
		);
		//
		~spatialGui[\hpfNumbox].add(thisSample ->
			NumberBox(~spatialGui[\filterWindows][thisSample], Rect(570, 60, 50, 50))
			.value_(20)
			.action_({arg val;
				val = val.value.linlin(20, 500, 0.0, 1.0);
				~spatialGui[\hpfFreq][thisSample].valueAction_(val);
				if(synths[j].isPlaying, {synths[j].set(\hpfFreq, val)});
			});
		);
	};
}.value;