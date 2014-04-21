/////////////////
// Peeling Apart
/////////////////


// BOOT SERVER (Ctrl + B)

// Evaluate SynthDef
(
SynthDef("smoothreverb", {|freq = 440, mix = 0.33, room = 0.5, damp = 0.5, trig = 0, att = 0, sus = 1, rel = 0, coef = 0.1, amp = 0.1, pan = 0, outbus = 0|
var env, snd;
env = EnvGen.kr(Env.linen(att, sus, rel), doneAction:2);
snd = Pluck.ar(
in: BrownNoise.ar(amp),
trig: Impulse.kr(trig),
maxdelaytime: freq.reciprocal,
delaytime: freq.reciprocal,
decaytime: sus,
coef: coef);
snd = Pan2.ar(snd, pan);
snd = FreeVerb.ar(snd, mix, room, damp);
Out.ar(0, Splay.ar(snd)*env);
}).add;
)

// Evaluate OSCdef (to receive messages from conductor)
(
OSCdef(\test, { arg ...args;
	Synth("smoothreverb", [
		\freq, args[0][1].midicps,
		\sus, args[0][2],
		\amp, args[0][3],
		\coef, args[0][4]
	]);
	args.postln },
	'/all');
)

