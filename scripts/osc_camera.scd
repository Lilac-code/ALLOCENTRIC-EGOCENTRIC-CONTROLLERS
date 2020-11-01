(

s = { arg freq=200, amp = 0.0;
	// SinOsc.ar(freq, 0.0, amp, 0.0);
	SinOsc.ar(freq*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,amp*0.3*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1])
}.play();

o = OSCFunc({ arg msg, time, addr, recvPort;

	// msg.postln;

	~amp = msg[3];
	if (~amp < 1000, {~amp=1000;}, {});
	if (~amp > 1400, {~amp=1400;}, {});

	~amp = ~amp - 1000;
	~amp = ~amp/400.0;

	~amp.postln;
	~ampp = 2.0 ** ~amp;
	~ampp = ~ampp - 1.0;

	s.set('amp', ~ampp);

},
'/leftWrist');

p = OSCFunc({ arg msg, time, addr, recvPort;

	msg.postln;

	~frq = msg[3];
	if (~frq < 1000, {~frq=1000;}, {});
	if (~frq > 1400, {~frq=1400;}, {});

	~frq = ~frq - 1000;
	~frq = ~frq/400.0;
	~frq = ~frq * 1.3;

	~frq = 2.0 ** ~frq;
	~frq = ~frq * 220.0;

	s.set('freq', ~frq);
.
	},
'/rightWrist');

)


o.free;


