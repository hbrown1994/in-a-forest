{
	~buffersNames[\spatial].do{|i|
		var thisSample=i.asSymbol;

		~spatialGui[\trig][thisSample].value = 0;

		~spatialGui[\amp][thisSample].value = ~params[thisSample][\amp];
		~spatialGui[\ampNumbox][thisSample].value = ~params[thisSample][\amp].ampdb;

		~spatialGui[\lpfOn][thisSample].value = ~params[thisSample][\lpfOn];
		~spatialGui[\hpfOn][thisSample].value = ~params[thisSample][\hpfOn];

		~spatialGui[\lpfFreq][thisSample].value = ~params[thisSample][\lpfFreq].linlin(4000, 20000, 0, 1);
		~spatialGui[\hpfFreq][thisSample].value = ~params[thisSample][\hpfFreq].linlin(20, 500, 0, 1);

		~spatialGui[\lpfNumbox][thisSample].value = ~params[thisSample][\lpfFreq];
		~spatialGui[\hpfNumbox][thisSample].value = ~params[thisSample][\hpfFreq];

		~spatialGui[\panSelMenu][thisSample].value =  ~params[thisSample][\panSel];
		~spatialGui[\panFreqSlider][thisSample].value =  ~params[thisSample][\panFreq].linlin(0.0, ~panFreqMax, 0.0, 1.0);
		~spatialGui[\panFreqNumbox][thisSample].value =  ~params[thisSample][\panFreq];
	};
}.value;




