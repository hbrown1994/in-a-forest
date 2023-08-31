{
	~buffersNames[\percussion].do{|i|
		var thisSample=i.asSymbol;


		~percGui[\trig][thisSample].value = 0;

		~percGui[\amp][thisSample].value = ~params[thisSample][\amp];
		~percGui[\ampNumbox][thisSample].value = ~params[thisSample][\amp].ampdb;

		~percGui[\lpfOn][thisSample].value = ~params[thisSample][\lpfOn];
		~percGui[\hpfOn][thisSample].value = ~params[thisSample][\hpfOn];


		~percGui[\lpfFreq][thisSample].value = ~params[thisSample][\lpfFreq].linlin(8000, 20000, 0, 1);
		~percGui[\hpfFreq][thisSample].value = ~params[thisSample][\hpfFreq].linlin(20, 200, 0, 1);

		~percGui[\lpfNumbox][thisSample].value = ~params[thisSample][\lpfFreq];
		~percGui[\hpfNumbox][thisSample].value = ~params[thisSample][\hpfFreq];

		8.do{|routeNum|
			var route = ("route"++routeNum).asSymbol;
			~percGui[\routeButtons][thisSample][route].value = ~params[thisSample][route];
		};


	};
}.value;





