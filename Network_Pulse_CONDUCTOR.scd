// Network Pulse piece
//
// This is the CONDUCTOR code
// Conductor sends a chord to all players
// Conductor controls the pulse (BPM)
// Original harmonices from Pbind by Reilly Farrell
// OSC stuff by Bruno Ruviaro

// All SCLOrk IPs here
// These IPs were hard-wired per machine
// using Xenakis network. lork-01 is first, lork-02 is second, etc.

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

// Define players available (in left to right order)
// 13 players available for June 4 2014 concert:
~players = [2, 3, 4, 5, 16, 7, 8, 9, 10, 11, 12, 13, 14];

// Define BPM
~bpm = Array.fill(8, 90);

// Load patterns
"Network_Pulse_PATTERNS.scd".loadRelative;

// Load MIDI
"Network_Pulse_CONDUCTOR_MIDI.scd".loadRelative;