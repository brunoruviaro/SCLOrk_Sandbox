/////////////////////////////
// Network Pulse
// General config for Players
// nanoKONTROL2
/////////////////////////////

s.waitForBoot({


	// ***********
	// VARIABLES
	// ***********

	~faders = Array.fill(7, { Bus.control(s, 1).set(0) });
	~knobs = Array.fill(7, 0.4);
	~strum = 0.0;
	~attack = 0.0;

	// ***********
	// MIDI Connections
	// ***********

	if(MIDIClient.sources.size==0,
		{ MIDIIn.connectAll },
		{ "MIDI already connected".postln }
	);

	// ***********
	// FADERS
	// ***********
	// Capture all FADER values from nanoKONTROL2
	// Set corresponding Bus.control values between 0-1
	// Fader 8 is an exception: it controls strum value (no bus)

	MIDIdef.cc(\faders,
		func: { arg value, ccNum;

			if(ccNum==7,
				// 8th fader controls strum value
				{
					~strum = value.linlin(0, 127, 0, 0.1).round(0.01);
					["fader 8 (strum)", ~strum].postln;
				},
				// all others control ampBus values for harmonics
				{
					value = value.linlin(0, 127, 0.0, 1.0);
					~faders[ccNum].set(value);
					["fader "++(ccNum+1), value.round(0.01)].postln;
				}
			);
		},
		ccNum: (0..7),
		chan: 0);


	// ***********
	// KNOBS
	// ***********
	// Capture all KNOB values from nanoKONTROL2
	// Set corresponding noteDur in Array
	// Knob 8 is an exception: it sets global attack time

	MIDIdef.cc(\knobs,
		func: { arg value, ccNum;

			if(ccNum==23,
				// 8th knob (CC 23) controls attack time
				{
					~attack = value.linlin(0, 127, 0.0, 0.2).round(0.001);
					["knob 8 (attack)", ~attack].postln;
				},
				// all others control noteDur of harmonics
				{
					value = value.linlin(0, 127, 0.2, 5);
					~knobs[ccNum-16] = value;
					["knob "++(ccNum-15), value.round(0.001)].postln;
				}
			);
		},
		ccNum: (16..23),
		chan: 0);


	// ***********
	// SynthDef
	// ***********

	SynthDef("smoothreverb2", {arg attack = 0, amp = 0.1, freq = 440, noteDur = 5, coef = 0.1, ampBus = 1;
		var env, snd;
		env = EnvGen.kr(Env.linen(attack, noteDur, 0.01), doneAction: 2) * ampBus;
		snd = Pluck.ar(
			in: BrownNoise.ar(amp),
			trig: Impulse.kr(0),
			maxdelaytime: 0.1,
			delaytime: freq.reciprocal,
			decaytime: noteDur,
			coef: coef);
		Out.ar(55, snd*env*0.5);
	}).add;

	// ***********
	// Reverb
	// ***********

	{ Limiter.ar(FreeVerb.ar(In.ar(55), 0.33, 0.5, 0.5), 0.8) }.play(addAction: \addToTail);


	// ***********
	// OSC listener
	// with Pbind
	// ***********
	OSCdef(\test, { arg ...args;
		var fundamental = args[0][1].midicps;
		var freqs = Array.series(7, fundamental, fundamental);

		Pbind(
			\instrument, "smoothreverb2",
			\freq, Pseq([freqs], 1),
			\amp, args[0][3],
			\coef, args[0][4],
			\noteDur, Pfunc({ ~knobs }), // array
			\ampBus, ~faders.collect({ |i| i.asMap; }),
			\strum, Pfunc({ ~strum }),
			\attack, Pfunc({ ~attack })
		).play;
		},
		path: '\all');




}); // end of waitForBoot

"END OF CONFIG FILE".postln;
"".postln;

