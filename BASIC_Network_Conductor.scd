// BASIC Network Conductor for quick testing
//
// This is the CONDUCTOR code
// Conductor sends a chord, one note to each player
// Conductor controls the pulse (BPM)

// Evaluate this block first:
(
var ips = [
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

~sendOSC = { arg player, message, path;

	player.do({ arg item, count;

		var myIP = ips.at(item-1); // player number - 1 = array index
		var myMsg = message.at(count);

		myIP.sendMsg(path, myMsg);
		["sent", myIP, myMsg].postln;
	});
};

~numberOfPlayers = ips.size;

("Number of IPs listed: " ++ ~numberOfPlayers).postln;

)

// Arguments "player" and "message" must be arrays, even if with a single item.
// For example,
// player: [1], message: [60]
// will send the message 60 to player 1.
// player: [1, 2, 4], message: [60, 65, 70]
// will send messages 60, 65, and 70 respectively to players 1, 2, and 4.

// Define players available
~players = [9, 14, 1, 15, 12, 4];

// Define a couple of chords
~chord1 = [48, 55, 58, 62, 63, 65];
~chord2 = [42, 56, 58, 63, 66, 70];

// Test it:
~sendOSC.value(~players, ~chord1, "/midinote");

// One player only (takes first note of chord):
~sendOSC.value([4], ~chord1, "/midinote");

// Two players:
~sendOSC.value([9, 4], ~chord1, "/midinote");

// Using BPM
// (Beats Per Minute)
// Evaluate once now, you can change this number
// and re-evaluate this line anytime
// to "conduct" the tempo of the pulse

~bpm = 50;

// Play it
(
Pbind(
	\type, \rest,
	\chords, Pseq([~chord1, ~chord2], inf),
	\osc, Pfunc({ |e| ~sendOSC.value(~players, e.at(\chords), "/midinote") }),
	\dur, Pfunc({ 1 / (~bpm/60) })
).play;
)

// Arpeggio:
(
Pbind(
	\type, \rest,
	\players, Pseq(~players, inf),
	\chords, Pseq(~chord1, inf),
	\osc, Pfunc({ |e| ~sendOSC.value([e.at(\players)], [e.at(\chords)], "/midinote") }),
	\dur, Pfunc({ 1 / (~bpm/60) })
).play;
)

// Arpeggio using both chords
(
Pbind(
	\type, \rest,
	\players, Pseq(~players, inf),
	\chords, Pseq([
		Pseq(~chord1, 1),
		Pseq(~chord2, 1)
		], inf),
	\osc, Pfunc({ |e| ~sendOSC.value([e.at(\players)], [e.at(\chords)], "/midinote") }),
	\dur, Pfunc({ 1 / (~bpm/60) / 6 })
).play;
)


// Control + period to stop sending messages.

// Conductor laptop can also be a player if you open and run the player file at the same time.
