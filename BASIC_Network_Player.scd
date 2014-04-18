// BASIC Network Player for quick test
//
// Boot the server
// Make sure you are connected to the proper network
// Run this line once:

OSCdef(\test, { arg ...args; (midinote: args[0][1]).play; args.postln }, '/midinote');