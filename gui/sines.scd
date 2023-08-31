{
	var window, compositeViews=List.new, sampleNames, numCompositeViews;
	var sineFreqs=#[324.3, 366.5, 367.0, 383.7];
	var synth0, synth1, synth2, synth3;
	var synths = [synth0, synth1, synth2, synth3];

	~sineGui = Dictionary.newFrom([
		\amp, Dictionary.new, \ampNumbox, Dictionary.new, \trig, Dictionary.new,
		\routeButtons, Dictionary.new
	]);

	numCompositeViews=sineFreqs.size;

	window = Window.new("Sines", Rect(200.rand, 200.rand, 400, 610)).front;
	window.view.decorator = FlowLayout( window.view.bounds, 0@0, 0@0 );

	numCompositeViews.do{|i| compositeViews.add(CompositeView( window.view, 100@610 ).background_( Color.cyan(val: ([0.6, 0.8]!5).flatten[i], alpha: 1.0) )) };

	compositeViews.do{|i, j|
		var f, inputText=[60, 80, 65, 55, 50];
		var thisSample = sineFreqs[j].asSymbol;
		f = StaticText(i, Rect(5, 5, 130, 20)).string = thisSample;
		f.font = Font("Helvetica", 18);

		~sineGui[\trig].add(thisSample ->
			Button(i, Rect(5, 30, 90, 50))
			.states_([["Play", Color.black, Color.grey], ["Off", Color.black, Color.red]])
			.action_({arg val;
				if(val.value==1, {
					if(synths[j].isPlaying, {nil}, {
						synths[j] = Synth(\sine, [\gate, 1,
							\amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp, \freq, sineFreqs[j],
							\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
							\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
						], ~nodes[\fixed]).register;
					});


				}, {if(synths[j].isPlaying, {synths[j].set(\gate, 0)});
				});
			});
		);


		//outputSlider
		StaticText(i, Rect(35, 80, 100, 20)).string = "Out";
		~sineGui[\amp].add(thisSample ->
			Slider(i, Rect(3, 100, 90, 300))
			.value_(1)
			.action_({arg val;
				~params[thisSample][\amp] = val.value;
				~sineGui[\ampNumbox][thisSample].value_(val.value.ampdb);
				if(synths[j].isPlaying, {synths[j].set(\amp, val.value)});
			});
		);

		//~sineGui[\ampNumbox]
		~sineGui[\ampNumbox].add(thisSample ->
			NumberBox(i, Rect(3, 400, 90, 20))
			.value_(0)
			.action_({arg val; ~sineGui[\amp][thisSample].valueAction_(val.value.dbamp)});
		);

		//routing
		{
			var routeDict = Dictionary.new;
			//routing
			8.do{|routeNum|
				var buttonName = ("route"++routeNum).asSymbol;
				var buttonSize=45;
				var buttonYStart = 425;

				~sineGui[\routeButtons].add(thisSample ->
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