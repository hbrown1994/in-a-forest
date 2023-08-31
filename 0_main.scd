
(
/*______________________________________________ 1. Server Configuration / Controller Init _________________________*/
s = Server.local; //Define server
s.options.blockSize = 64;           //server blocksize (as small as possible, mainly for latency and InFeedback.kr/ar)`
s.newBusAllocators;                 //allocate busses on the server
s.latency = 0.05;                   //as little latency as possible between the language and the server
s.options.numOutputBusChannels = 8; //8 inputs and outputs
s.options.numInputBusChannels = 12;
s.options.memSize = 2.pow(21);
s.options.numAudioBusChannels = 100000;
s.options.maxNodes = 11000;
s.options.recHeaderFormat = "wav";
s.options.numWireBufs = 128 * 128;
Buffer.freeAll;

//Clean up server just in case something is running
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
//

/*______________________________________________ 2. Global Variables/Init Singeltons ______________________________________________*/
~parentPath = PathName(thisProcess.nowExecutingPath).parentPath;
~path = Dictionary.newFrom(
	[
		\buffers, ~parentPath++"buffers/",
		\init, ~parentPath++"init/",
		\synthdefs, ~parentPath++"synthdefs/",
		\gui, ~parentPath++"gui/",
		\run, ~parentPath++"run/",
		\reset, ~parentPath++"reset/",
		\save, ~parentPath++"save/",
		\load, ~parentPath++"load/",
		\kill, ~parentPath++"kill/",
		\startup, ~parentPath++"startup/",
		\makeGui, ~parentPath++"makeGui/",
		\synthTrigger, ~parentPath++"synthTrigger/",
		\presets, ~parentPath++"presets/"
	]
);

~buffers = Dictionary.new;
~buffersNames = Dictionary.new;
~nodes = Dictionary.new;

~inputSynths = List.new;
~sendSynths = List.new;
~forestSynths = Dictionary.new;
~fxSynths = Dictionary.new;

~inputSynthNames = [\inputSynth0, \inputSynth1, \inputSynth2, \inputSynth3, \inputSynth4];
~sendSynthNames = [\sendSynth0, \sendSynth1, \sendSynth2, \sendSynth3, \sendSynth4];
~fxNames = [\bitCrusher, \harmonizer, \reverb, \octaver];

~instrumentNames = ["Flute", "Clarinet", "Violin", "Perc", "Vox"];

~masterAmp=0;

~panFreqMax = 5;

/*______________________________________________ 3. Server. Cleanup ______________________________________________*/
//Cleanup server on command period/Server quit
~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

ServerQuit.add(~cleanup);

~cmdPeriodCleanup = {

};

CmdPeriod.add(~cmdPeriodCleanup);

/*______________________________________________ 4. Executing on Server Boot ______________________________________________*/
s.waitForBoot({ //Wait to boot server once contained functions have been evaluated.
	var rout;

	thisProcess.interpreter.executeFile(~path[\init]++"make_busses.scd");
	s.sync;

	thisProcess.interpreter.executeFile(~path[\startup]++"make_buffers.scd");

	s.sync;

	thisProcess.interpreter.executeFile(~path[\startup]++"init_params.scd");

	s.sync;

	PathName(~path[\synthdefs]).entries.do{|i|
		(i.entries).do{|j| thisProcess.interpreter.executeFile(j.fullPath)}
	};

	s.sync;

	PathName(~path[\gui]).entries.do{|i|
		thisProcess.interpreter.executeFile(i.fullPath)
	};

	s.sync;

		/*MAKE GUI_____________*/
	PathName(~path[\makeGui]).entries.do{|i|
		thisProcess.interpreter.executeFile(i.fullPath)
	};

	s.sync;
	s.freeAll;
	s.sync;
	s.meter;
	s.plotTree;
	"done".postln;
});
);