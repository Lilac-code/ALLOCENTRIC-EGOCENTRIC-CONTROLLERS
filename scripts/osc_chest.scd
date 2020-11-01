(

s = { arg freq=200, amp = 0.0;
	f = Lag2UD.kr(freq, 0.1, 0.1);
	a = Lag2UD.kr(amp, 0.1, 0.1);
	SinOsc.ar(f*[0.7,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,a*0.7*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1])
}.play();


o = OSCFunc({ arg msg, time, addr, recvPort;

	// msg.postln;

	~ampX = msg[1];
	~ampY = msg[2];
	~ampZ = msg[3];

	~amp = sqrt(((~ampX - ~chestX)**2) + ((~ampY - ~chestY)**2) + ((~ampZ - ~chestZ)**2));

	if (~amp < 200, {~amp=200;}, {});
	if (~amp > 800, {~amp=800;}, {});

	~amp = ~amp - 200.0;
	~amp = ~amp/(800.0 - 200.0);

	~amp.postln;
	~ampp = 2.0 ** ~amp;
	~ampp = ~ampp - 1.0;

	s.set('amp', ~ampp);

},
'/leftWrist');

p = OSCFunc({ arg msg, time, addr, recvPort;

	msg.postln;

	~frqX = msg[1];
	~frqY = msg[2];
	~frqZ = msg[3];

	~frq = sqrt(((~frqX - ~chestX)**2) + ((~frqY - ~chestY)**2) + ((~frqZ - ~chestZ)**2));

	if (~frq < 100, {~frq=100;}, {});
	if (~frq > 800, {~frq=800;}, {});

	~frq = ~frq - 100.0;
	~frq = ~frq/(800.0 - 100.0);
	~frq = ~frq * 2.6;

	~frq = 2.0 ** ~frq;
	~frq = ~frq * 440;

	s.set('freq', ~frq);

	},
'/rightWrist');

o = OSCFunc({ arg msg, time, addr, recvPort;
	// msg.postln;

	~chestX = msg[1];
	~chestY = msg[2];
	~chestZ = msg[3];

},
'/spineChest');

)


o.free;

{Mix(SinOsc.ar(1220*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]))}.scope

{Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1))}.scope

[1,2,3,4]**3;

~tamps = (((20..1)/20)**3)
~tamps_normalized = ~tamps / sum(~tamps)
~tfrqs = ((1..20)*920)


{Mix(SinOsc.ar(~tfrqs, 0, ~tamps))}.play

NetAddr.langPort;
NetAddr.localAddr

OSCFunc.trace(true);

(

SynthDef.new("tutorial-args", { arg freq = 440, out = 0;
    Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).send(s);

)

s.scope;

x = Synth.new("tuto`rial-args");
x.set("freq", 160);
x.set("out", 1);

Server.default = Server.internal;
s = Server.default;
s.boot;

SynthDef("tuto", { Out.ar(0, SinOsc.ar(440 + 200.rand, 0, 0.2)) }).send(s);


// used to lag pitch
(
SynthDef( \lag2ud_help, { |out, freq=300, lagup=1, lagdown=5|
    Out.ar(out,
        SinOsc.ar( // sine wave
            Lag2UD.kr( // lag the frequency
                freq,
                lagup,
                lagdown
            ),
            0, // phase
            0.2 // sine amplitude
        )
    );
}).add;
)

x = Synth(\lag2ud_help); // create the synth

x.set(\lagup, 0.05);
x.set(\lagdown, 0.05);

x.set(\freq, 1500); // set the frequency to a higher value (takes 1 second)
x.set(\freq, 300); // set the frequency to a lower value (takes 5 seconds)
x.free;