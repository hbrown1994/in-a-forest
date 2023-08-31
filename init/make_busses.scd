~busses = Dictionary.new;

~sendSynthNames.do{|i|
	~busses.add(i -> Bus.audio(s, 2));
};

