{
	var presetGuiMain, presetName=nil, menu, save, load, run, kill, overwrite, delete, channels, synthLoad, ampNum;                  //a Gui method in which all the above methods are executed.
	var controlsDict, presetNamesArray, globalPath, synths, loader, classes, numChannels=2, midiOut, recorders, outputSynthChan, synthLemur, mixerLemur, stateLemur, osc, masterAmp=0;
	var path =~path[\presets],   presetExists=0;

	//init preset array
	if(Object.readArchive(path++"presetNames").isCollection,          //Read a file containing the preset names as a List and assign to a global class variable;
		{presetNamesArray = Object.readArchive(path++"presetNames")}, //If Object from disk is a list, assign to class variable;
		{"No Presets".postln; presetNamesArray=List.new(0)}           //If Object from disk is NOT a list, make new List and assign to class variable;
	);

	~mainGui = Dictionary.new;

	presetGuiMain = Window.new("PresetManager", Rect(0, 600, 410, 280)).front;  //Make window
	TextField(presetGuiMain, Rect(10, 10, 120, 20)).action_({arg val; presetName=val.value});  //preset name
	menu = PopUpMenu(presetGuiMain, Rect(150, 10, 120, 20)).value_(0).items = presetNamesArray.asArray; //Populate PopUpMenu with presetNamesArray

	save = Button(presetGuiMain, Rect(10, 40, 75, 75/2)) //A button that loops through each class in "classes" and calls their .save methods on mouseDown
	.states_([["Save", Color.black, Color.yellow]])           //Each class' .save methods adds all of their control patameters to a dictionary
	.mouseDownAction_({
		{
			if(~inputSynths[0].isPlaying, {
				if(presetName.isString, {                                 //if: preset is a String, Run function | Else: print "Preset Name is Not String"
					(presetNamesArray.size+1).do{|i|                      //Iterate over presets:
						if(i==(presetNamesArray.size) && presetExists==0,   // if: the preset name already exists, stop loop and post "Preset Exists"|Else: save preset
							{~params.writeArchive(path++presetName); presetNamesArray.add(presetName).writeArchive(path++"presetNames")},
							{
								if(presetNamesArray[i]==presetName, {"Preset Exists".postln; presetExists=1});
								if(presetName=="", {"Not Valid".postln; presetExists=1});
							}
						);
					}
				}, {"Preset Name is Not String".postln})
			}, {"Need To Run".postln});
		}.value;
	})
	.mouseUpAction_({
		menu.items=presetNamesArray.asArray;
	});

	Button(presetGuiMain, Rect(10, 90, 75, 75/2)) //A button that loads a preset from disk and distributes the control data to
	.states_([["Load", Color.black, Color.green]])            //each synth/control class via their individual .load methods
	.mouseDownAction_({
		presetName =  presetNamesArray[menu.value];
		~params = Object.readArchive(path++presetNamesArray[menu.value]);
		PathName(~path[\kill]).entries.do{|i|
			thisProcess.interpreter.executeFile(i.fullPath)
		};
	})
	.mouseUpAction_({
		PathName(~path[\load]).entries.do{|i|
			thisProcess.interpreter.executeFile(i.fullPath)
		};
	});

	Button(presetGuiMain, Rect(10, 140, 75, 75/2)) //Delete preset on disk on mouseDown & update the popUpMenu items on mouseUp
	.states_([["Delete", Color.black, Color.cyan]])
	.mouseDownAction_({
		File.delete(path++presetNamesArray[menu.value]);
		presetNamesArray.removeAt(presetNamesArray.asArray.find([presetNamesArray[menu.value]]));

	})
	.mouseUpAction_({
		menu.items=presetNamesArray.asArray;
		presetNamesArray.writeArchive(path++"presetNames")
	});

	Button(presetGuiMain, Rect(150, 40, 75, 75/2))
	.states_([["INIT RUN", Color.black, Color.white]])
	.mouseDownAction_({
		PathName(~path[\init]).entries.do{|i|
			thisProcess.interpreter.executeFile(i.fullPath)
		};
	})
	.mouseUpAction_({
		PathName(~path[\run]).entries.do{|i|
			thisProcess.interpreter.executeFile(i.fullPath)
		};
	});

	Button(presetGuiMain, Rect(150, 90, 75, 75/2)) //A button that loads a preset from disk and distributes the control data to
	.states_([["STOP", Color.black, Color.red]])            //each synth/control class via their individual .load methods
	.action_({arg msg;
		CmdPeriod.run;
	});

	overwrite = Button(presetGuiMain, Rect(10, 190, 75, 75/2))   //Overwrite the preset currently selected in the pop-up window
	.states_([["Overwrite", Color.black, Color.red]])
	.mouseDownAction_({File.delete(path++presetName)})
	.mouseUpAction_({~params.writeArchive(path++presetName)});


	Button(presetGuiMain, Rect(150, 140, 75, 75/2))   //Add synthDefs to server (used when changing number of output channels)
	.states_([["Reset", Color.black, Color.magenta]])
	.mouseDownAction_({CmdPeriod.run})
	.mouseUpAction_({
		PathName(~path[\reset]).entries.do{|i|
			thisProcess.interpreter.executeFile(i.fullPath)
		};

		PathName(~path[\run]).entries.do{|i|
			thisProcess.interpreter.executeFile(i.fullPath)
		};
	});

	~mainGui.add(\masterSlider ->
		Slider(presetGuiMain, Rect(350, 3, 50, 255))  //Make a slider/numBox to control whole system's output gain
		.value_(0.0)
		.action_({arg msg;
			~masterAmp = msg.value;
			~mainGui[\masterNumbox].value = msg.value.ampdb;
			if(~inputSynths[0].isPlaying, {
				~inputSynths.do{|i| i.set(\masterAmp,  msg.value)};
			});

			~fxSynths.keysDo{|i|
				if(~fxSynths[i].isPlaying, {~fxSynths[i].set(\masterAmp,  msg.value)});
			};

			~forestSynths.keysDo{|i|
				if(~forestSynths[i].isPlaying, {~forestSynths[i].set(\masterAmp,  msg.value)});
			};

		});
	);

	~mainGui.add(\masterNumbox ->
		NumberBox(presetGuiMain, Rect(350, 258, 50, 20)).value_(-inf).action_({arg val;
			~mainGui[\masterSlider].valueAction = val.value.dbamp;
		});
	);

	StaticText(presetGuiMain, Rect(230, 190, 75, 30)).string_("Live Output");
	~mainGui.add(\mainOut -> NumberBox(presetGuiMain, Rect(150, 190, 75, 30))
		.value_(0)
		.action_({arg val;
			~params[\mainOut]=val.value.asInteger;
			~inputSynthNames.do{|i, j|
				~params[i][\out]=val.value.asInteger;
				~inputGui[\out][j].valueAction=val.value.asInteger;
			};
		});
	);

	StaticText(presetGuiMain, Rect(230, 230, 90, 30)).string_("Forest Output Start");
	~mainGui.add(\forestOut -> NumberBox(presetGuiMain, Rect(150, 230, 75, 30))
		.value_(2)
		.action_({arg val;
			~params[\forestOut]=val.value.asInteger;
		});
	);

	StaticText(presetGuiMain, Rect(250, 80, 100, 30)).string_("Forest Number  of Channels");
	~mainGui.add(\forestOutputChannels -> NumberBox(presetGuiMain, Rect(250, 40, 75, 30))
		.value_(6)
		.action_({arg val;
			~params[\forestOutputChannels]=val.value.asInteger;
		});
	);

	StaticText(presetGuiMain, Rect(230-140, 230, 75, 50)).string_("Spatial Output Start");
	~mainGui.add(\spatialOut -> NumberBox(presetGuiMain, Rect(150-140, 240, 75, 30))
		.value_(0)
		.action_({arg val;
			~params[\spatialOut]=val.value.asInteger;
		});
	);

	StaticText(presetGuiMain, Rect(250, 160, 100, 30)).string_("Spatial Number  of Channels");
	~mainGui.add(\spatialOutputChannels -> NumberBox(presetGuiMain, Rect(250, 120, 75, 30))
		.value_(8)
		.action_({arg val;
			~params[\spatialOutputChannels]=val.value.asInteger;
		});
	);
}.value;



