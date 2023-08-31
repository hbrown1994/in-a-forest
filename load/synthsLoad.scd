PathName(~path[\run]).entries.do{|i|
	thisProcess.interpreter.executeFile(i.fullPath)
};

~fxSynths.keysDo{|i|
	if(~fxSynths[i].isPlaying, ~fxSynths[i].set(\gate, 0));
};