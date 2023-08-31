{
	var params = [\amp, \trigRate, \posLow, \posHigh, \rateLow, \rateHigh, \durLow, \durHigh, \pan, \sizeLow, \sizeHigh, \hpf, \lpf, \atkLow, \atkHigh, \relLow, \relHigh];
	var paramsMin =  [0, 0.1, 0, 0,  0.1,  0.1, 0.0001, 0.0001, 0,  0.001, 0.001, 20,   6000, 0.001, 0.001, 0.001, 0.001];
	var paramsMax = [1, 40,  1, 1,  10,  10,  4,        4,         1, 3,        3,        300, 20000, 5, 5, 5, 5];

	~forest1Gui[\onOff].value = 0;

	params.do{|i, j|

		~forest1Gui[\paramSlider][i].value = ~params[\forest1][i].linlin(paramsMin[j], paramsMax[j], 0.0, 1.0);
		~forest1Gui[\paramNumbox][i].value = ~params[\forest1][i];

	};

}.value;





