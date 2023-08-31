Routine{

	thisProcess.interpreter.executeFile(~path[\startup]++"init_params.scd");


	s.sync;

	PathName(~path[\makeGui]).entries.do{|i|
		thisProcess.interpreter.executeFile(i.fullPath)
	};


	"GUI Made".postln;

}.play(AppClock);


