PathName(~path[\buffers]).entries.do{
	arg subfolder;
	~buffers.add(
		subfolder.folderName.asSymbol ->
		Array.fill(
			subfolder.entries.size,
			{
				arg i;
				Buffer.read(s, subfolder.entries[i].fullPath);
			}
		)
	);
};

 PathName(~path[\buffers]).entries.do{
		arg subfolder;
		~buffersNames.add(
			subfolder.folderName.asSymbol ->
			Array.fill(
				subfolder.entries.size,
				{
					arg i;
					subfolder.entries[i].fileName.asString.replace(".wav", "");
				}
			)
		);
	};


