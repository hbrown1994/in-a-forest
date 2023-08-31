PathName(~path[\synthdefs]).entries.do{|i|
	(i.entries).do{|j| thisProcess.interpreter.executeFile(j.fullPath)}
};