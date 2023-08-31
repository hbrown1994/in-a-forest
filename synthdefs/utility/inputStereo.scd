SynthDef(\inputStereo, {
	arg in1, in2, out, amp=0, busAmp=0, gate=1, pan=0, lpfOn=0, hpfOn=0, lpfFreq=21000, hpfFreq=20, masterAmp=1;
	var sig, env;

	sig = SoundIn.ar(in1) + SoundIn.ar(in2);

	sig = Select.ar(lpfOn.lag(0.005), [sig, LPF.ar(sig, lpfFreq)]);
	sig = Select.ar(hpfOn.lag(0.005), [sig, HPF.ar(sig, hpfFreq)]);

	env = EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = Pan2.ar(sig, pan);

	sig = sig * amp * env * masterAmp;

	Out.ar(out, sig);
}).add;






