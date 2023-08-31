if(~nodes[\fixed].isPlaying,
	{
		2.do{|i|
			if(i==0,
				{~nodes.keysDo{|i| ~nodes[i].free}},
				{
					~nodes = Dictionary.new;

					~nodes.add(\forest -> Group.new);
					~nodes.add(\fixed -> Group.after(~nodes[\forest]));
					~nodes.add(\input -> Group.after(~nodes[\fixed]));
					~nodes.add(\sends -> Group.after(~nodes[\input]));
					~nodes.add(\fx -> Group.after(~nodes[\sends]));
					~nodes.add(\output -> Group.after(~nodes[\fx]));

					~nodes.keysDo{|i|
						NodeWatcher.register(~nodes[i], true);
					};
				}
			);
		}
	},
	{
		~nodes = Dictionary.new;

		~nodes.add(\forest -> Group.new);
		~nodes.add(\fixed -> Group.after(~nodes[\forest]));
		~nodes.add(\input -> Group.after(~nodes[\fixed]));
		~nodes.add(\sends -> Group.after(~nodes[\input]));
		~nodes.add(\fx -> Group.after(~nodes[\sends]));
		~nodes.add(\output -> Group.after(~nodes[\fx]));

		~nodes.keysDo{|i|
			NodeWatcher.register(~nodes[i], true);
		};
	}
);