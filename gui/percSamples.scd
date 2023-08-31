{
	var window, compositeViews=List.new, sampleNames, numCompositeViews;
	var synths = Array.newClear(10);

	~percGui = Dictionary.newFrom([
		\filterWindows, Dictionary.new, \filterButtons, Dictionary.new,
		\amp, Dictionary.new, \ampNumbox, Dictionary.new, \trig, Dictionary.new,
		\lpfOn, Dictionary.new, \lpfFreq, Dictionary.new, \lpfNumbox, Dictionary.new, \hpfOn, Dictionary.new, \hpfFreq, Dictionary.new, \hpfNumbox, Dictionary.new,
		\routeButtons, Dictionary.new

	]);

	numCompositeViews=~buffersNames[\percussion].size;

	window = Window.new("Perc Samples", Rect(200.rand, 200.rand, 1000, 640)).front;
	window.view.decorator = FlowLayout( window.view.bounds, 0@0, 0@0 );

	numCompositeViews.do{|i| compositeViews.add(CompositeView( window.view, 100@640 ).background_( Color.green(val: ([0.6, 0.8]!5).flatten[i], alpha: 1.0) )) };

	compositeViews.do{|i, j|
		var f, inputText=[60, 80, 65, 55, 50];
		var thisSample = ~buffersNames[\percussion][j].asSymbol;
		f = StaticText(i, Rect(5, 5, 130, 20)).string = thisSample;
		f.font = Font("Helvetica", 18);

		if(j==6, {
			/*loop*/
			~percGui[\trig].add(thisSample ->
				Button(i, Rect(5, 30, 90, 50))
				.states_([["Loop", Color.black, Color.grey], ["Off", Color.black, Color.red]])
				.action_({arg val;
					if(val.value==1, {
						if(synths[j].isPlaying, {nil}, {
							synths[j] = Synth(\loop, [\gate, 1,
								\buf, ~buffers[\vox][j],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
								\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
								\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
								\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
							], ~nodes[\fixed]).register;
						});
					}, {if(synths[j].isPlaying, {synths[j].set(\gate, 0)})});
				});
			);
		}, {if(j==7, {
			/*loop*/
			~percGui[\trig].add(thisSample ->
				Button(i, Rect(5, 30, 90, 50))
				.states_([["Loop", Color.black, Color.grey], ["Off", Color.black, Color.red]])
				.action_({arg val;
					if(val.value==1, {
						if(synths[j].isPlaying, {nil}, {
							synths[j] = Synth(\loop, [\gate, 1,
								\buf, ~buffers[\vox][j],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
								\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
								\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
								\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
							], ~nodes[\fixed]).register;
						});
					}, {if(synths[j].isPlaying, {synths[j].set(\gate, 0)})});
				});
			);
		}, {
			/*everything else*/
			~percGui[\trig].add(thisSample ->
				Button(i, Rect(5, 30, 90, 50))
				.states_([["Play", Color.black, Color.grey]])
				.action_({arg val;
					if(synths[j].isPlaying, {synths[j].set(\t_trig, 1)}, {
						synths[j] = Synth(\oneShot, [\t_trig, 1,
							\buf, ~buffers[\percussion][j],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
							\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
							\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
							\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]

						], ~nodes[\fixed]);
					});
				});
			);
		})});

		//outputSlider
		StaticText(i, Rect(35, 80, 100, 20)).string = "Out";
		~percGui[\amp].add(thisSample ->
			Slider(i, Rect(3, 100, 90, 300))
			.value_(1)
			.action_({arg val;
				~params[thisSample][\amp] = val.value;
				~percGui[\ampNumbox][thisSample].value_(val.value.ampdb);
				if(synths[j].isPlaying, {synths[j].set(\amp, val.value)});
			});
		);

		//~percGui[\ampNumbox]
		~percGui[\ampNumbox].add(thisSample ->
			NumberBox(i, Rect(3, 400, 90, 20))
			.value_(0)
			.action_({arg val;
				~percGui[\amp][thisSample].valueAction_(val.value.dbamp);
				if(synths[j].isPlaying, {synths[j].set(\amp, val.value.dbamp)});
			});
		);

		//filters
		~percGui[\filterWindows].add(thisSample -> Window.new("Filters: "++thisSample.asString, Rect(30, 100, 630, 120)).visible=false);

		~percGui[\filterButtons].add(thisSample -> Button(i, Rect(3, 423, 90, 30))
			.states_([["Filters", Color.black, Color.magenta], ["Close", Color.black, Color.red]])
			.action_({arg val; if(val.value==1, {~percGui[\filterWindows][thisSample].visible=true}, {~percGui[\filterWindows][thisSample].visible=false})});
		);


		//filtersOnOff
		~percGui[\lpfOn].add(thisSample ->
			Button(~percGui[\filterWindows][thisSample], Rect(3, 3, 60, 50))
			.states_([["LPF", Color.black, Color.green], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[thisSample][\lpfOn] = val.value;
				if(synths[j].isPlaying, {synths[j].set(\lpfOn, val.value)});

			});
		);
		//
		~percGui[\hpfOn].add(thisSample ->
			Button(~percGui[\filterWindows][thisSample], Rect(3, 60, 60, 50))
			.states_([["HPF", Color.black, Color.magenta], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[thisSample][\hpfOn] = val.value;
				if(synths[j].isPlaying, {synths[j].set(\hpfOn, val.value)});
			});
		);
		//
		~percGui[\lpfFreq].add(thisSample ->
			Slider(~percGui[\filterWindows][thisSample], Rect(65, 3, 500, 50))
			.value_(1)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 8000, 20000);
				~percGui[\lpfNumbox][thisSample].value_(val);
				~params[thisSample][\lpfFreq] = val;
				if(synths[j].isPlaying, {synths[j].set(\lpfFreq, val)});
			});
		);
		//
		~percGui[\lpfNumbox].add(thisSample ->
			NumberBox(~percGui[\filterWindows][thisSample], Rect(570, 3, 50, 50))
			.value_(20000)
			.action_({arg val;
				val = val.value.linlin(8000, 20000, 0.0, 1.0);
				~percGui[\lpfFreq][thisSample].valueAction_(val);
				if(synths[j].isPlaying, {synths[j].set(\lpfFreq, val)});
			});
		);
		//
		~percGui[\hpfFreq].add(thisSample ->
			Slider(~percGui[\filterWindows][thisSample], Rect(65, 60, 500, 50))
			.value_(0)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 20,  200);
				~percGui[\hpfNumbox][thisSample].value_(val);
				~params[thisSample][\hpfFreq] = val;
				if(synths[j].isPlaying, {synths[j].set(\hpfFreq, val)});
			});
		);
		//
		~percGui[\hpfNumbox].add(thisSample ->
			NumberBox(~percGui[\filterWindows][thisSample], Rect(570, 60, 50, 50))
			.value_(20)
			.action_({arg val;
				val = val.value.linlin(20, 200, 0.0, 1.0);
				~percGui[\hpfFreq][thisSample].valueAction_(val);
				if(synths[j].isPlaying, {synths[j].set(\hpfFreq, val)});
			});
		);
		//routing
		{
			var routeDict = Dictionary.new;
			//routing
			8.do{|routeNum|
				var buttonName = ("route"++routeNum).asSymbol;
				var buttonSize=45;
				var buttonYStart = 455;

				~percGui[\routeButtons].add(thisSample ->
					routeDict.add(buttonName ->
						Button(i, Rect([3, buttonSize+5][routeNum%2], [buttonYStart!2, (buttonYStart+(buttonSize*1))!2, (buttonYStart+(buttonSize*2))!2, (buttonYStart+(buttonSize*3))!2].flatten[routeNum], buttonSize, buttonSize))
						.states_([[routeNum.asString, Color.black, Color.grey], [routeNum.asString, Color.black, Color.red]])
						.action_({arg val;
							~params[thisSample][buttonName]=val.value;
						});
					);
				);
			};
		}.value;
	};
}.value;