// Network Pulse piece
// 2014-05-19

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
		{ "nothing to do".postln }
	);
	},
	ccNum: (32..39)
);


MIDIdef.cc(\knobs, { arg value, ccNum;
	var index = ccNum - 16;
	~bpm[index] = value.linlin(0, 127, 30, 120).round(1);
	["index", index, "bpm", ~bpm[index] ].postln;
	},
	ccNum: (16..23)
);
