{
	var controlsGui;        //a Gui method in which all the above methods are executed.

	~controlsGui = Dictionary.new;

	controlsGui = Window.new("Controls", Rect(0, 260, 410, 280)).front;  //Make window

	Button(controlsGui, Rect(5,5,100,100))
	.states_([["FXs", Color.black, Color.red], ["Close FXs", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~fxGui[\window].visible = true;
			},
			{
				~fxGui[\window].visible = false;
			}
	)});

	Button(controlsGui, Rect(105,5,100,100))
	.states_([["Sines", Color.black, Color.cyan(0.6)], ["Close Sines", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~sineGui[\window].visible = true;
			},
			{
				~sineGui[\window].visible = false;
			}
	)});

	Button(controlsGui, Rect(205,5,100,100))
	.states_([["Perc Samples", Color.black, Color.green(0.6)], ["Close Perc", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~percGui[\window].visible=true;
			},
			{
				~percGui[\window].visible=false;
			}
	)});

	Button(controlsGui, Rect(305,5,100,100))
	.states_([["Vox Samples", Color.black, Color.yellow(0.8)], ["Close Vox", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~voxGui[\window].visible=true;
			},
			{
				~voxGui[\window].visible=false;
			}
	)});

	Button(controlsGui, Rect(5,105,100,100))
	.states_([["Forest0", Color.black, Color.new255(196, 164, 132)], ["Close Forest0", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~forest0Gui[\window].visible = true;
			},
			{
				~forest0Gui[\window].visible = false;
			}
	)});

	Button(controlsGui, Rect(105,105,100,100))
	.states_([["Forest1", Color.black, Color.new255(139,112,88)], ["Close Forest1", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~forest1Gui[\window].visible = true;
			},
			{
				~forest1Gui[\window].visible = false;
			}
	)});

	Button(controlsGui, Rect(205,105,100,100))
	.states_([["Spatial Samples", Color.black, Color.red(0.8)], ["Close Spatial", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~spatialGui[\window].visible = true;
			},
			{
				~spatialGui[\window].visible = false;
			}
	)});
}.value;



