{
	~buffersNames[\vox].do{|i|
		var thisSample=i.asSymbol;

		~voxGui[\trig][thisSample].value = 0;

		~voxGui[\amp][thisSample].value = ~params[thisSample][\amp];
		~voxGui[\ampNumbox][thisSample].value = ~params[thisSample][\amp].ampdb;

		~voxGui[\lpfOn][thisSample].value = ~params[thisSample][\lpfOn];
		~voxGui[\hpfOn][thisSample].value = ~params[thisSample][\hpfOn];


		~voxGui[\lpfFreq][thisSample].value = ~params[thisSample][\lpfFreq].linlin(8000, 20000, 0, 1);
		~voxGui[\hpfFreq][thisSample].value = ~params[thisSample][\hpfFreq].linlin(20, 200, 0, 1);

		~voxGui[\lpfNumbox][thisSample].value = ~params[thisSample][\lpfFreq];
		~voxGui[\hpfNumbox][thisSample].value = ~params[thisSample][\hpfFreq];

		8.do{|routeNum|
			var route = ("route"++routeNum).asSymbol;
			~voxGui[\routeButtons][thisSample][route].value = ~params[thisSample][route];
		};


	};
}.value;




