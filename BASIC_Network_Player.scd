// BASIC Network Player for quick test
//
// Boot the server
// Make sure you are connected to the proper network
// Run this line once:

OSCdef(\test, { arg ...args; (midinote: args[0][1]).play; args.postln }, '/midinote');






// Or try with a plucking sound.
// Evaluate SynthDef once,
// Then run last block of code (OSCdef)

(
SynthDef("plucking", {arg amp = 0.1, freq = 440, decay = 5, coef = 0.1;
var env, snd;
env = EnvGen.kr(Env.linen(0, decay, 0), doneAction: 2);
snd = Pluck.ar(
        in: WhiteNoise.ar(amp),
        trig: Impulse.kr(0),

        maxdelaytime: 0.1,
        delaytime: freq.reciprocal,
        decaytime: decay,
        coef: coef);
    Out.ar(0, [snd, snd]);
}).add;
)


// OSCdef with plucking synth
(
OSCdef(\test, { arg ...args;
	Synth("plucking", [\freq, args[0][1].midicps]);
	args.postln },
	'/midinote');
)

