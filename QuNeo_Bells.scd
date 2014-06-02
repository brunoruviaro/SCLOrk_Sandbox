// ************************************
// Additive Synthesis Demo with QuNEO
// Patch 4 - Risset Bell with Attack/Release controls
// 2014-06-02
// ************************************

/*

Implements Risset's Bell with option to change its envelope.
Uses QuNEO SCLOrk Preset #1 (but adaptable to any MIDI controller).
Each pad plays a transposition of the bell.
First vertical slider controls attack time.
Long Slider controls release time.

Default MIDI channel: 12 (11 in SC)
Incoming MIDI notes: 36-99
Slider controlling attack: CC# 6
Slider controlling release: CC# 10

*/

s.waitForBoot({

	var padsArray = Array.newClear(64);
	var release = 4;
	var attack = 0.005;
	var curve = -4.5;
	var quneoChannel = 11;

	// hack
	if(MIDIClient.sources.size==0,
		{ MIDIIn.connectAll },
		{ "MIDI already connected".postln }
	);

	MIDIdef.freeAll;

	MIDIdef.noteOn(
		key: \noteOn,
		func: {arg vel, note;
			var index = note - 36; // start from 0
			padsArray[index] = Synth("risset2", [
				\freq, (note+12).midicps,
				\amp, vel.linlin(0, 127, 0.01, 0.1),
				\att, attack,
				\rel, release])},
		noteNum: (36..99), // only pad notes (16 x 4 banks)
		chan: quneoChannel);

	// No need for noteOff responder, as bells are just attack-release

	// Attack (first Vertical Slider)
	MIDIdef.cc(
		key: \attack,
		func: {arg val, ccnum;
			attack = val.linexp(0, 127, 0.005, 4);
			curve = if(attack < 0.01, { -4.5 }, { val.linlin(0, 127, -4, 1) });

			[
				"Attack",attack.round(0.001),
				"Release", release.round(0.01),
				"Curve", curve.round(0.01)
		].postln },

		ccNum: 6, // Long Slider
		chan: quneoChannel);

	// Release (Long Slider)
	MIDIdef.cc(
		key: \release,
		func: {arg val, ccnum;
			release = val.linlin(0, 127, 0.05, 10);
			[
				"Attack",attack.round(0.01),
				"Release", release.round(0.01)
		].postln  },
		ccNum: 10, // Long Slider
		chan: quneoChannel);



	SynthDef(\risset2, {|out = 0, pan = 0, freq = 400, amp = 0.1, att = 0.005, rel = 2, gate = 1|
		var amps = #[1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33];
		var durs = #[1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075];
		var frqs = #[0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07];
		var dets = #[0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0];
		var doneActionEnv = EnvGen.ar(Env.linen(0, att+rel, 0), gate, doneAction: 2);
		var src = Mix.fill(11, {|i|
			var env = EnvGen.ar(Env.perc(att, rel * durs[i], amps[i], att.explin(0.005, 4, -4.5, 0)), gate);
			SinOsc.ar(freq*frqs[i] + dets[i], 0, amp*env);
		});
		src = src * doneActionEnv * 0.5; // make sure it releases node after the end.
		Out.ar(out, Pan2.ar(src, pan));
	}).add;

	FreqScope.new
});