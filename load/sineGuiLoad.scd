{
	[367.0, 366.5, 383.7, 324.3].do{|i|
		var thisSample=i.asSymbol;

		~sineGui[\trig][thisSample].value = 0;

		~sineGui[\amp][thisSample].value = ~params[thisSample][\amp];
		~sineGui[\ampNumbox][thisSample].value = ~params[thisSample][\amp].ampdb;

		8.do{|routeNum|
			var route = ("route"++routeNum).asSymbol;
			~sineGui[\routeButtons][thisSample][route].value = ~params[thisSample][route];
		};

	};
}.value;





