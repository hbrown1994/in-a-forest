{
	var  inputWindow, inputComp,  resetButtons, setAllOutputs, soloArrays;

	~inputGui = Dictionary.newFrom([
		\instrumentNames, ["Flute", "Clarinet", "Violin", "Perc", "Vox"], \in1, List.new, \in2, List.new, \in3, List.new, \stereoMono, List.new,
		\isSoloed, List[0, 0, 0, 0, 0], \isMuted, List[0, 0, 0, 0, 0], \out, List.new, \soloButtons, List.new,  \muteButtons, List.new,
	]);

	~dryGui = Dictionary.newFrom([
		\amp, List.new, \ampNumbox, List.new, \filterButtons, List.new, \filterWindows, List.new, \lpfOn, List.new, \hpfOn, List.new,
		\lpfFreq, List.new, \lpfNumbox, List.new, \hpfFreq, List.new, \hpfNumbox, List.new, \pan, List.new, \panNumbox, List.new,
	]);

	~sendGui  = Dictionary.newFrom([
		\amp, List.new, \ampNumbox, List.new, \filterButtons, List.new, \filterWindows, List.new, \lpfOn, List.new, \hpfOn, List.new,
		\lpfFreq, List.new, \lpfNumbox, List.new, \hpfFreq, List.new, \hpfNumbox, List.new, \pan, List.new, \panNumbox, List.new,
	]);

	soloArrays = [
		[ 1, 2, 3, 4 ],
		[ 2, 3, 4, 0 ],
		[ 3, 4, 0, 1 ],
		[ 4, 0, 1, 2 ],
		[ 0, 1, 2, 3 ]
	];

	inputComp = List.new;

	inputWindow = Window.new("Inputs", Rect(0, 600, 1200, 500)).front;
	inputWindow.view.decorator = FlowLayout( inputWindow.view.bounds, 0@0, 0@0 );

	resetButtons = List.new;

	5.do{|i| inputComp.add(CompositeView( inputWindow.view, 240@500 ).background_( Color.gray(gray: [1.0, 0.75, 0.5, 0.75, 1.0][i], alpha: 1.0) )) };

	inputComp.do{|i, j|
		var f, inputText=[60, 80, 65, 55, 50];
		var thisInstrument = ~inputGui[\instrumentNames][j];
		f = StaticText(i, Rect(5, 5, 100, 20)).string = ~inputGui[\instrumentNames][j];
		f.font = Font("Helvetica", 18);

		if(thisInstrument=="Perc", {~inputGui[\stereoMono].add(nil)}, {
			//stereo on/pff
			~inputGui[\stereoMono].add(Button(i, Rect(3, 30, 60, 50))
				.states_([["Mono", Color.black, Color.green], ["Stereo", Color.black, Color.cyan]])
				.action_({arg view; if(view.value==1,
					{
						~params[~inputSynthNames[j]][\stereoMono] = \inputStereo;
						~params[~sendSynthNames[j]][\stereoMono] = \inputStereo;
					},
					{
						~params[~inputSynthNames[j]][\stereoMono] = \input;
						~params[~sendSynthNames[j]][\stereoMono] = \input;
					}
				)});
			);
		});

		//reset Synth
		Button(i, Rect(if(thisInstrument=="Perc", {3}, {(3+62)}), 30, 60, 50))
		.states_([["Reset", Color.black, Color.red]])
		.mouseDownAction_({
			~inputSynths.size.do{|q|
				if(~inputSynths[q].isPlaying, {~inputSynths[q].set(\gate, 0)});
				if(~sendSynths[q].isPlaying, {~sendSynths[q].set(\gate, 0)});
			};

			thisProcess.interpreter.executeFile(~path[\init]++"make_synthArrays.scd");
		})
		.mouseUpAction_({
			PathName(~path[\run]).entries.do{|i|
				thisProcess.interpreter.executeFile(i.fullPath)
			};
		});

		Button(i, Rect(if(thisInstrument=="Perc", {65}, {130}), 50, 80, 30))
		.states_([["Set All Outs", Color.black, Color.yellow]])
		.mouseDownAction_({
			~mainGui[\liveOuput].value = ~inputGui[\out][j].value.asInteger;
		})
		.mouseUpAction_({
			5.do{|q| ~inputGui[\out][q].valueAction = ~inputGui[\out][j].value}
		});


		//Input Channel Set
		StaticText(i, Rect(inputText[j]+32, 3, 100, 20)).string = "Input 1";
		~inputGui[\in1].add(TextField(i, Rect(inputText[j], 4, 30, 20)).string_(j.asString)
			.action = {arg val;
				~params[~inputSynthNames[j]][\in1] = val.value.asInteger;
				~params[~sendSynthNames[j]][\in1] = val.value.asInteger;
		}); //set input channell

		//Input Channel Set
		StaticText(i, Rect(inputText[j]+(80+32), 4, 100, 20)).string = "Input 2";
		~inputGui[\in2].add(TextField(i, Rect(inputText[j]+(80), 4, 30, 20)).string_((j+5).asString)
			.action = {arg val;
				~params[~inputSynthNames[j]][\in2] = val.value.asInteger;
				~params[~sendSynthNames[j]][\in2] = val.value.asInteger;
		}); //set input channell

		if(thisInstrument=="Perc", {
			//Input Channel Set
			StaticText(i, Rect(inputText[j]+(80+38), 25, 100, 20)).string = "Input 3";
			~inputGui[\in3].add(TextField(i, Rect(inputText[j]+(88), 25, 30, 20)).string_((j+10).asString)
				.action = {arg val;
					~params[~inputSynthNames[j]][\in3] = val.value.asInteger;
					~params[~sendSynthNames[j]][\in3] = val.value.asInteger;
			}); //set input channell
		});

		//Output Channel Set

		StaticText(i, Rect(if(thisInstrument=="Perc", {inputText[j]+32+10}, {inputText[j]+(80+32)}), 25, 45, 20)).string = "Output";
		~inputGui[\out].add(TextField(i, Rect(if(thisInstrument=="Perc", {inputText[j]+10}, {inputText[j]+(80)}), 25, 30, 20)).string_(0.asString)
			.action = {arg val;
				~params[~inputSynthNames[j]][\out] = val.value.asInteger;
		}); //set input channell


		//outputSlider
		StaticText(i, Rect(35, 80, 100, 20)).string = "Out";
		~dryGui[\amp].add(
			Slider(i, Rect(3, 100, 90, 300))
			.value_(0)
			.action_({arg val;
				~params[~inputSynthNames[j]][\amp] = val.value;
				if(~inputSynths[j].isPlaying, {~inputSynths[j].set(\amp, val.value)});
				~dryGui[\ampNumbox][j].value_(val.value.ampdb);
			});
		);

		//~dryGui[\ampNumbox]
		~dryGui[\ampNumbox].add(
			NumberBox(i, Rect(3, 400, 90, 20))
			.value_(-inf)
			.action_({arg val; ~dryGui[\amp][j].valueAction_(val.value.dbamp)});
		);

		//filters
		~dryGui[\filterWindows].add(Window.new("Filters: "++~inputGui[\instrumentNames][j]++" OUT", Rect(30, 100, 630, 120)).visible=false);

		~dryGui[\filterButtons].add(Button(i, Rect(3, 423, 90, 30))
			.states_([["Filters", Color.black, Color.magenta], ["Close", Color.black, Color.red]])
			.action_({arg val; if(val.value==1, {~dryGui[\filterWindows][j].visible=true}, {~dryGui[\filterWindows][j].visible=false})});
		);

		//filtersOnOff
		~dryGui[\lpfOn].add(
			Button(~dryGui[\filterWindows][j], Rect(3, 3, 60, 50))
			.states_([["LPF", Color.black, Color.green], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[~inputSynthNames[j]][\lpfOn] = val.value;
				if(~inputSynths[j].isPlaying, {~inputSynths[j].set(\lpfOn, val.value)});
			});
		);

		~dryGui[\hpfOn].add(Button(~dryGui[\filterWindows][j], Rect(3, 60, 60, 50))
			.states_([["HPF", Color.black, Color.magenta], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[~inputSynthNames[j]][\hpfOn] = val.value;
				if(~inputSynths[j].isPlaying, {~inputSynths[j].set(\hpfOn, val.value)});
			});
		);

		~dryGui[\lpfFreq].add(
			Slider(~dryGui[\filterWindows][j], Rect(65, 3, 500, 50))
			.value_(1)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 8000, 20000);
				~dryGui[\lpfNumbox][j].value_(val);
				~params[~inputSynthNames[j]][\lpfFreq] = val;
				if(~inputSynths[j].isPlaying, {~inputSynths[j].set(\lpfFreq, val)});
			});
		);

		~dryGui[\lpfNumbox].add(
			NumberBox(~dryGui[\filterWindows][j], Rect(570, 3, 50, 50))
			.value_(20000)
			.action_({arg val;
				val = val.value.linlin(8000, 20000, 0.0, 1.0);
				~dryGui[\lpfFreq][j].valueAction_(val)
			});
		);

		~dryGui[\hpfFreq].add(
			Slider(~dryGui[\filterWindows][j], Rect(65, 60, 500, 50))
			.value_(0)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 20,  200);
				~dryGui[\hpfNumbox][j].value_(val);
				~params[~inputSynthNames[j]][\hpfFreq] = val;
				if(~inputSynths[j].isPlaying, {~inputSynths[j].set(\hpfFreq, val)});
			});
		);

		~dryGui[\hpfNumbox].add(
			NumberBox(~dryGui[\filterWindows][j], Rect(570, 60, 50, 50))
			.value_(20)
			.action_({arg val;
				val = val.value.linlin(20, 200, 0.0, 1.0);
				~dryGui[\hpfFreq][j].valueAction_(val)
			});
		);

		//panning
		~dryGui[\pan].add(Knob(i, Rect(-10, 463, 70, 30))
			.value_(0.5)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, -1.0, 1.0);
				~params[~inputSynthNames[j]][\pan] = val.value;
				if(~inputSynths[j].isPlaying, {~inputSynths[j].set(\pan, val.value)});
				~dryGui[\panNumbox][j].value = val;
			});
		);

		~dryGui[\panNumbox].add(
			NumberBox(i, Rect(45, 463, 50, 30))
			.value_(0)
			.action_({arg val;
				~dryGui[\hpfNumbox][j].valueAction = val.value.linlin(-1.0, 1.0, 0.0, 1.0);
			});
		);

		//SEND_---------------------------
		StaticText(i, Rect(30+100, 80, 100, 20)).string = "Send";
		~sendGui[\amp].add(
			Slider(i, Rect(3+100, 100, 90, 300))
			.value_(0)
			.action_({arg val;
				~params[~sendSynthNames[j]][\amp] = val.value;
				if(~sendSynths[j].isPlaying, {~sendSynths[j].set(\amp, val.value)});
				~sendGui[\ampNumbox][j].valueAction_(val.value.ampdb);
			});
		);

		//~sendGui[\ampNumbox]
		~sendGui[\ampNumbox].add(
			NumberBox(i, Rect(3+100, 400, 90, 20))
			.value_(-inf)
			.action_({arg val; ~sendGui[\amp][j].value_(val.value.dbamp)});
		);

		//filters
		~sendGui[\filterWindows].add(Window.new("Filters: "++~inputGui[\instrumentNames][j]++" SENDS", Rect(30+100, 100, 630, 120)).visible=false);

		~sendGui[\filterButtons].add(Button(i, Rect(3+100, 423, 90, 30))
			.states_([["Filters", Color.black, Color.magenta], ["Close", Color.black, Color.red]])
			.action_({arg view; if(view.value==1, {~sendGui[\filterWindows][j].visible=true}, {~sendGui[\filterWindows][j].visible=false})});
		);

		//filtersOnOff
		~sendGui[\lpfOn].add(Button(~sendGui[\filterWindows][j], Rect(3, 3, 60, 50))
			.states_([["LPF", Color.black, Color.green], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[~sendSynthNames[j]][\lpfOn] = val.value;
				if(~sendSynths[j].isPlaying, {~sendSynths[j].set(\lpfOn, val.value)});
			});
		);

		~sendGui[\hpfOn].add(Button(~sendGui[\filterWindows][j], Rect(3, 60, 60, 50))
			.states_([["HPF", Color.black, Color.magenta], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[~sendSynthNames[j]][\hpfOn] = val.value;
				if(~sendSynths[j].isPlaying, {~sendSynths[j].set(\hpfOn, val.value)});
			});
		);

		~sendGui[\lpfFreq].add(
			Slider(~sendGui[\filterWindows][j], Rect(65, 3, 500, 50))
			.value_(1)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 8000, 20000);
				~sendGui[\lpfNumbox][j].value_(val);
				~params[~sendSynthNames[j]][\lpfFreq] = val;
				if(~sendSynths[j].isPlaying, {~sendSynths[j].set(\lpfFreq, val)});
			});
		);

		~sendGui[\lpfNumbox].add(
			NumberBox(~sendGui[\filterWindows][j], Rect(570, 3, 50, 50))
			.value_(20000)
			.action_({arg val;
				val = val.value.linlin(8000, 20000, 0.0, 1.0);
				~sendGui[\lpfFreq][j].valueAction_(val)
			});
		);

		~sendGui[\hpfFreq].add(
			Slider(~sendGui[\filterWindows][j], Rect(65, 60, 500, 50))
			.value_(0)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 20,  200);
				~sendGui[\hpfNumbox][j].value_(val);
				~params[~sendSynthNames[j]][\hpfFreq] = val;
				if(~sendSynths[j].isPlaying, {~sendSynths[j].set(\hpfFreq, val)});
			});
		);

		~sendGui[\hpfNumbox].add(
			NumberBox(~sendGui[\filterWindows][j], Rect(570, 60, 50, 50))
			.value_(20)
			.action_({arg val;
				val = val.value.linlin(20, 200, 0.0, 1.0);
				~sendGui[\hpfFreq][j].valueAction_(val)
			});
		);


		~sendGui[\pan].add(Knob(i, Rect(90, 463, 70, 30))
			.value_(0.5)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, -1.0, 1.0);
				~params[~sendSynthNames[j]][\pan] = val.value;
				if(~sendSynths[j].isPlaying, {~sendSynths[j].set(\pan, val.value)});
				~sendGui[\panNumbox][j].value = val;
			});
		);

		~sendGui[\panNumbox].add(
			NumberBox(i, Rect(90+55, 463, 50, 30))
			.value_(0)
			.action_({arg val;
				~sendGui[\pan][j].valueAction = val.value.linlin(-1.0, 1.0, 0.0, 1.0);
			});
		);

		//GLOBALS
		~inputGui[\soloButtons].add(
			Button(i, Rect(196, 100, 40, 40))
			.states_([["S", Color.black, Color.white], ["S", Color.black, Color.yellow]])
			.action_({arg val; var anySynthMuted;
				if(val.value==1,
					{
						~inputGui[\isSoloed][j] = 1;
						if(~inputGui[\isMuted][j]==1, {
							~inputGui[\isMuted][j]=0;
							~inputGui[\muteButtons][j].value = 0;
							if(~inputSynths[j].isPlaying, {~inputSynths[j].set(\amp, ~params[~inputSynthNames[j]][\amp])});
							if(~sendSynths[j].isPlaying, {~sendSynths[j].set(\amp, ~params[~sendSynthNames[j]][\amp])});

						});
						soloArrays[j].do{|q|
							if(~inputGui[\isSoloed][q]==0, {
								if(~inputSynths[q].isPlaying, {~inputSynths[q].set(\amp, 0)});
								if(~sendSynths[q].isPlaying, {~sendSynths[q].set(\amp, 0)});
								~inputGui[\isMuted][q] = 1;
							});
						};
					},
					{
						~inputGui[\isSoloed][j] = 0;
						{
							var anySynthSoloed=0;
							5.do{|q|
								if(q==4, {
									if(anySynthSoloed>=1, {
										if(~inputSynths[j].isPlaying, {~inputSynths[j].set(\amp, 0)});
										if(~sendSynths[j].isPlaying, {~sendSynths[j].set(\amp, 0)});
										~inputGui[\isMuted][j] = 1;
									},
									{
										5.do{|k|
											if(~inputSynths[k].isPlaying, {~inputSynths[k].set(\amp, ~params[~inputSynthNames[k]][\amp])});
											if(~sendSynths[k].isPlaying, {~sendSynths[k].set(\amp, ~params[~sendSynthNames[k]][\amp])});
											~inputGui[\isMuted][k] = 0;
											~inputGui[\muteButtons][k].value = 0;
										}
									});
								},
								{
									anySynthSoloed = anySynthSoloed + ~inputGui[\isSoloed][soloArrays[j][q]];
								}
								);
							};
						}.value;
					}
				);
			});
		);

		~inputGui[\muteButtons].add(
			Button(i, Rect(196, 145, 40, 40))
			.states_([["M", Color.black, Color.grey], ["M", Color.black, Color.red]])
			.action_({arg val;
				if(val.value==1,
					{
						~inputGui[\isMuted][j] = 1;
						if(~inputSynths[j].isPlaying, {~inputSynths[j].set(\amp, 0)});
						if(~sendSynths[j].isPlaying, {~sendSynths[j].set(\amp, 0)});
					},
					{
						{
							var anySynthSoloed=0;
							5.do{|q|
								if(q==4, {
									if(anySynthSoloed>=1, {nil},
										{
											~inputGui[\isMuted][j] = 0;
											if(~inputSynths[j].isPlaying, {~inputSynths[j].set(\amp, ~params[~inputSynthNames[j]][\amp])});
											if(~sendSynths[j].isPlaying, {~sendSynths[j].set(\amp, ~params[~sendSynthNames[j]][\amp])});
									});
								},
								{
									anySynthSoloed = anySynthSoloed + ~inputGui[\isSoloed][soloArrays[j][q]];
								}
								);
							};
						}.value;
					}
				);
			});
		);
	};
}.value;