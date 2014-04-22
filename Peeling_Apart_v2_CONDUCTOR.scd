// PEELING APART v2
//
// This is the CONDUCTOR code
// Conductor sends a chord to all players
// Conductor controls the pulse (BPM)
// Original Pbind by Reilly Farrell
// OSC stuff by Bruno Ruviaro


// All SCLOrk IPs here
~ips = [
	NetAddr("192.168.1.101", 57120),
	NetAddr("192.168.1.102", 57120),
	NetAddr("192.168.1.103", 57120),
	NetAddr("192.168.1.104", 57120),
	NetAddr("192.168.1.105", 57120),
	NetAddr("192.168.1.106", 57120),
	NetAddr("192.168.1.107", 57120),
	NetAddr("192.168.1.108", 57120),
	NetAddr("192.168.1.109", 57120),
	NetAddr("192.168.1.110", 57120),
	NetAddr("192.168.1.111", 57120),
	NetAddr("192.168.1.112", 57120),
	NetAddr("192.168.1.113", 57120),
	NetAddr("192.168.1.114", 57120),
	NetAddr("192.168.1.115", 57120),
	NetAddr("192.168.1.116", 57120),
];

// Define players available
~players = [9, 14, 1, 15, 12, 4];

// Define BPM
~bpm = Array.fill(8, 90);

// Create array for patterns
~patternArray = Array.fill(8, nil);

// Filling the array with patterns (all paused to begin)
// Each has their own BPM

// Reilly's "Peeling Apart" Pbind
// 6-note chords so far
// Variation 0 (original)
~patternArray[0] = Pbind(
	\type, \rest,
	\scale, Pseq([
		Prand([Pn(Scale.major, 12), Pn(Scale.lydian, 12)], 1),
		Prand([Pn(Scale.major, 12), Pn(Scale.locrian, 12), Pn(Scale.lydian, 12)], 1),
		Prand([Pn(Scale.minor, 24), Pn(Scale.major, 24)], 1),
	], inf),
	\degree, Pseq([
		Pseq([[-6, 3, 3, 5, 7, 9], [3, 4, 4, 7, 9, 9]], 12),
		Pseq([[-4, 3, 5, 5, 7, 9], [3, 4, 4, 7, 9, 9]], 12),
	], inf),
	// \strum, Pseries(0.01, 0.0000016, 5000),
	\ctranspose, Prand([Pn(-11, 24), Pn(-9, 24), Pn(-8, 24)], inf),
	\myMidi, Pkey(\degree).degreeToKey(Pkey(\scale), 12) + 60 + Pkey(\ctranspose),
	\dur, Pfunc({ 1 / (~bpm[0]/60) } / 4),
	\sus, Pseries(2, -0.0002, 5000),
	\amp, Prand([
		Pseq([
			Pwhite(0.7, 0.8, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.8, 0.9, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1)
		], 1),
		Pseq([
			Pwhite(0.7, 0.8, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.8, 0.9, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1)
		], 1),
	], inf),
	\coef, Pwhite(Pseries(0.7, -0.00012, 5000), Pseries(0.8, -0.00014, 5000)),
	// \print, Pfunc({ |e| [e.at(\myMidi), e.at(\sus), e.at(\amp), e.at(\coef) ].round(0.01).postln }),
	\osc, Pfunc({ |e|
		~players.do({ arg item, count;
			var myIP = ~ips.at(item-1);

			myIP.sendMsg("/all",
				e.at(\myMidi).at(count),
				e.at(\sus).round(0.001),
				e.at(\amp).round(0.001),
				e.at(\coef).round(0.001)
		)})
	})
).play.pause;

// Variation 1

~patternArray[1] = Pbind(
	\type, \rest,
	\scale, Pseq([
		Prand([Pn(Scale.major, 12), Pn(Scale.lydian, 12)], 1),
		Prand([Pn(Scale.major, 12), Pn(Scale.locrian, 12), Pn(Scale.lydian, 12)], 1),
		Prand([Pn(Scale.minor, 24), Pn(Scale.major, 24)], 1),
	], inf),
	\degree, Pseq([
		Pseq([[-6, 3, 3, 5, 7, 9], [3, 4, 4, 7, 9, 9]], 12),
		Pseq([[-4, 3, 5, 5, 7, 9], [3, 4, 4, 7, 9, 9]], 12),
	], inf),
	// \strum, Pseries(0.01, 0.0000016, 5000),
	\ctranspose, Prand([Pn(-11, 24), Pn(-9, 24), Pn(-8, 24)], inf),
	\myMidi, Pkey(\degree).degreeToKey(Pkey(\scale), 12) + 60 + Pkey(\ctranspose),
	\dur, Pfunc({ 1 / (~bpm[1]/60) } / 4),
	\sus, Pseries(2, -0.0002, 5000),
	\amp, Prand([
		Pseq([
			Pwhite(0.7, 0.8, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.8, 0.9, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1)
		], 1),
		Pseq([
			Pwhite(0.7, 0.8, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.8, 0.9, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1)
		], 1),
	], inf),
	\coef, Pwhite(Pseries(0.7, -0.00012, 5000), Pseries(0.8, -0.00014, 5000)),
	// \print, Pfunc({ |e| [e.at(\myMidi), e.at(\sus), e.at(\amp), e.at(\coef) ].round(0.01).postln }),
	\players, Pfunc({ [~players.choose, ~players.choose] }),
	\osc, Pfunc({ |e|
		e.at(\players).do({ arg item, count;
			var myIP = ~ips.at(item-1);

			myIP.sendMsg("/all",
				e.at(\myMidi).at(count),
				e.at(\sus).round(0.001),
				e.at(\amp).round(0.001),
				e.at(\coef).round(0.001)
		)})
	})
).play.pause;

// Variation 2
~patternArray[2] = Pbind(
	\type, \rest,
	\scale, Pseq([
		Prand([Pn(Scale.major, 12), Pn(Scale.lydian, 12)], 1),
		Prand([Pn(Scale.major, 12), Pn(Scale.locrian, 12), Pn(Scale.lydian, 12)], 1),
		Prand([Pn(Scale.minor, 24), Pn(Scale.major, 24)], 1),
	], inf),
	\degree, Pseq([
		Pseq([-6, 3, 3, 5, 7, 9, 3, 4, 4, 7, 9, 9], 6),
		Pseq([-4, 3, 5, 5, 7, 9, 3, 4, 4, 7, 9, 9], 6),
	], inf),
	// \strum, Pseries(0.01, 0.0000016, 5000),
	\ctranspose, Prand([Pn(-11, 24), Pn(-9, 24), Pn(-8, 24)], inf),
	\myMidi, Pkey(\degree).degreeToKey(Pkey(\scale), 12) + 60 + Pkey(\ctranspose),
	\dur, Pfunc({ 1 / (~bpm[2]/60) } / 4),
	\sus, Pseries(2, -0.0002, 5000),
	\amp, Prand([
		Pseq([
			Pwhite(0.7, 0.8, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.8, 0.9, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1)
		], 1),
		Pseq([
			Pwhite(0.7, 0.8, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.8, 0.9, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1),
			Pwhite(0.4, 0.5, 1)
		], 1),
	], inf),
	\coef, Pwhite(Pseries(0.7, -0.00012, 5000), Pseries(0.8, -0.00014, 5000)),
	// \print, Pfunc({ |e| [e.at(\myMidi), e.at(\sus), e.at(\amp), e.at(\coef) ].round(0.01).postln }),
	\players, Pseq(~players ++ ~players.reverse, inf),
	\osc, Pfunc({ |e|
		~ips.at(e.at(\players)-1).sendMsg("/all",
			e.at(\myMidi),
			e.at(\sus).round(0.001),
			e.at(\amp).round(0.001),
			e.at(\coef).round(0.001)
		)
	})
).play.pause;

// END OF PATTERNS


// ***********
// MIDI stuff
// ***********

if(MIDIClient.sources.size==0,
	{ MIDIIn.connectAll },
	{ "MIDI already connected".postln }
);


~current = 99;

MIDIdef.cc(\soloButtons, { arg value, ccNum;
	var index = ccNum - 32;

	if( (~current != index) && (value == 127),
		{
			// 99 accounts for first-time-play
			if(~current!=99, { ~patternArray[~current].pause });
			~patternArray[index].resume;
			~current = index;
			["current", index, "bpm", ~bpm[index] ].postln;
		},
		{ "nothing to do" }
	);
	},
	ccNum: (32..39)
);


MIDIdef.cc(\knobs, { arg value, ccNum;
	var index = ccNum - 16;
	~bpm[index] = value.linlin(0, 127, 30, 120).round(1);
	~bpm[index].postln;
	},
	ccNum: (16..23)
);
