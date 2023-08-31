SynthDef(\forestTrig0,{
	arg trigRate=2, dur=0.1, posLow=0, posHigh=1, rateLow=0.5, rateHigh=2, durLow=0.01, durHigh=0.8, pan=0, sizeLow=0.2, sizeHigh=1, amp=0.8, hpf=20, lpf=20000, atkLow=0.005, atkHigh=0.005, relLow=0.005, relHigh=0.005;
	SendReply.kr(
		Dust.kr(trigRate),
		'/forest0',
		[posLow, posHigh, rateLow, rateHigh, durLow, durHigh, pan, sizeLow, sizeHigh, amp, hpf, lpf, atkLow, atkHigh, relLow, relHigh]
	);
}).add;


