(

s = { arg freq=200, amp = 0.0;
	// SinOsc.ar(freq, 0.0, amp, 0.0);
	SinOsc.ar(freq*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,amp*0.7*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1])
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

q = OSCFunc({ arg msg, time, addr, recvPort;

	// msg.postln;

	~rwX = msg[1];
	~rwY = msg[2];
	~rwZ = msg[3];

	},
'/rightWristCalib');

r = OSCFunc({ arg msg, time, addr, recvPort;

	// msg.postln;

	~lwX = msg[1];
	~lwY = msg[2];
	~lwZ = msg[3];

	},
'/rightWristCalib');


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

