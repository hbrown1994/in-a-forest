["voxSamplesGuiLoad.scd", "sineGuiLoad.scd", "percSamplesGuiLoad.scd", "fxGuiLoad.scd", "inputGuiLoad.scd", "mainGuiLoad.scd", "forest0GuiLoad.scd", "forest1GuiLoad.scd", "spatialSamplesGuiLoad.scd"].do{|i|
	thisProcess.interpreter.executeFile(~path[\load]++i);
};




