// Network Pulse piece
//
// CONDUCTOR PATTERNS
// this file generates data to send over OSC to other laptops



// Create array for patterns
~patternArray = Array.fill(8, nil);

// Filling the array with patterns (all paused to begin)
// Each has their own BPM

// Variation 0 (original)

~patternArray[0] = Pchain(
	Pbind(\dur, Pfunc({ 1 / (~bpm[0]/60) } / 4)),
	~oscChord, // 3. orchestrate
	~mainPattern, // 2. create notes etc
	~mainChords // 1. feed this first
).play.pause;


// Variation 1

~patternArray[1] = Pchain(
	Pbind(\dur, Pfunc({ 1 / (~bpm[1]/60) } / 4)),
	~oscDuoRand, // 3. orchestrate
	~mainPattern, // 2. create notes etc
	~mainChords // 1. feed this first
).play.pause;


// Variation 2

~patternArray[2] = Pchain(
	Pbind(\dur, Pfunc({ 1 / (~bpm[2]/60) } / 4)),
	~oscBackAndForth,
	~mainPattern,
	~mainArpeggio
).play.pause;


////////////////
// Definitions
////////////////

~chord1 = [-6, 3, 3, 5, 7, 9, -6, 9, 7, 5, 3, 3, -6];
~chord2 = [3, 4, 4, 7, 9, 9, 3, 9, 9, 7, 4, 4, 3];
~chord3 = [-4, 3, 5, 5, 7, 9, -4, 9, 7, 5, 5, 3, -4];

~mainPattern = Pbind(
	\type, \rest,
	\scale, Pseq([
		Prand([Pn(Scale.major, 12), Pn(Scale.lydian, 12)], 1),
		Prand([Pn(Scale.major, 12), Pn(Scale.locrian, 12), Pn(Scale.lydian, 12)], 1),
		Prand([Pn(Scale.minor, 24), Pn(Scale.major, 24)], 1),
	], inf),
	\ctranspose, Prand([Pn(-11, 24), Pn(-9, 24), Pn(-8, 24)], inf),
	\myMidi, Pkey(\degree).degreeToKey(Pkey(\scale), 12) + 60 + Pkey(\ctranspose),
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
);


~mainChords = Pbind(
	\degree, Pseq([
		Pseq([ ~chord1, ~chord2 ], 12),
		Pseq([ ~chord3, ~chord2 ], 12),
	], inf)
);

~mainArpeggio = Pbind(
	\degree, Pseq([
		Pseq(~chord1, 6),
		Pseq(~chord2, 6),
	], inf)
);

// Distribute one note to each player, play simultaneously
~oscChord = Pbind(
	\print, Pfunc({ |e| [e.at(\myMidi), e.at(\sus), e.at(\amp), e.at(\coef) ].round(0.01).postln }),
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
);

// Choose any two players, play simultaneously
~oscDuoRand = Pbind(
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
);

// Sweep left to right and then back (one player at a time)
~oscBackAndForth = Pbind(
	\players, Pseq(~players ++ ~players.reverse, inf),
	\osc, Pfunc({ |e|
		~ips.at(e.at(\players)-1).sendMsg("/all",
			e.at(\myMidi),
			e.at(\sus).round(0.001),
			e.at(\amp).round(0.001),
			e.at(\coef).round(0.001)
		)
	})
);



"Network_Pulse_PATTERNS.scd loaded".postln;

/*


p = Pbind(\type, \rest, \midinote, Pwhite(60, 70));

q = Pbind(\dur, 0.25);


p.trace.play

q.trace.play



*/
