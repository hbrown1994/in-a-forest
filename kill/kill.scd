[~path[\init]++"make_nodes.scd", ~path[\init]++"make_synthArrays.scd"].do{|i|
	thisProcess.interpreter.executeFile(i);
};