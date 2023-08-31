[
	~path[\init]++"make_midi_perc.scd",
	~path[\init]++"make_midi_vox.scd",

	~path[\init]++"make_busses.scd",
	~path[\init]++"make_nodes.scd",
	~path[\init]++"make_synthArrays.scd"].do{|i|
	thisProcess.interpreter.executeFile(i);
};

PathName(~path[\makeGui]).entries.do{|i|
	thisProcess.interpreter.executeFile(i.fullPath)
};