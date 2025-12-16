
//: 1 Working with envelopes without release node.
//: Common Env constructor shortcuts: perc, triangle, sine, linen, step, cutoff.
//: Try out all the shortcuts from above:
{
	[\perc, \triangle, \sine, \linen, \step, \cutoff] do: { | type |
		type.postln;
		Env.perform(type).test;
		1.wait;
	}
}.fork;
//:

//  The shape of the above envelopes is fixed,
//  but one can control when to release or free the synth.
// 
//: IMPORTANT: To free a synth when the envelope ends, add doneAction 2:
// 					Note: 2 here is value for doneAction argument
a = { SinOsc.ar(440) * Env.perc.kr(2) }.play; // synth frees end of perc envelope.

// Counterexample:
//: If you do not add doneAction 2, then the synth stays on after the envelope finishes 
a = { SinOsc.ar(440) * Env.perc.kr }.play;
// The envelope ends, and the synth becomes silent, but keeps running.
// So one must release or free the synth explicitly to free the synth:
a.release;

// 2. Working with envelopes that have a release node.
// Constructors are: Env.adsr, Env.asr
// Alternatively one can specify the release node explicitly in the specifications:
Env([0, 1, 1, 0], [0.5, 1, 0.5], releaseNode: 2);
//:Using an envelope with a release node:
a = { SinOsc.ar(440) * Env([0, 1, 1, 0], [0.5, 1, 0.5], releaseNode: 2).kr(2) }.play;
//:Release the synth at any point
a.release; // NOTE: release default duration 0.02 overrides default adsr release duration.
//: Example: A long envelope with random shape:
a = {
	SinOsc.ar(440) *
	Env([0] ++ Array.rand(18, 0.01, 0.5) ++ [0], Array.rand(19, 0.05, 1.5), 8, 18)
	.kr(2);
}.play;
//:
a release: 0.5; // custom release time 0.5
//:Simpler example: adsr
a = { SinOsc.ar(440) * Env.adsr.kr(2) }.play; //
//:release manually to stop
a.release;
//: Envelope that is triggered at any point 
a = { SinOsc.ar(440) * Env.perc.kr(0, \gate2.tr) }.play; // waits until triggered!
//:Trigger the gate2 control to hear the perc envelope:
a.set(\gate2, 1);
//: Can trigger many times
{
	var a, shape;
	shape = Array.geom(90, 1, 0.95);
	a = { SinOsc.ar(\freq.kr(400)) * Env.perc.kr(0, \gate2.tr) }.play;
	0.1.wait;
	shape do: { | d |
		a.set(\gate2, 1, \freq, 900 - d.linlin(0.0001, 1.0, 400, 600));
		d.wait;
	};
	a release: 2;
}.fork;
//: Two crossing curves
{
	var a, b, shape, shape2;
	shape = Array.geom(90, 1, 0.95);
	shape2 = shape.reverse;
	a = { SinOsc.ar(\freq.kr(400)) * Env.perc.kr(0, \gate2.tr) * 0.1 }.play;
	b = { SinOsc.ar(\freq.kr(400)) * Env.perc.kr(0, \gate2.tr) * 0.1 }.play;
	0.1.wait;
	{
		shape do: { | d |
			a.set(\gate2, 1, \freq, 900 - d.linlin(0.0001, 1.0, 400, 600));
			d.wait;
		};
		a release: 2;
	}.fork;
	{
		shape2 do: { | d |
			b.set(\gate2, 1, \freq, d.linlin(0.0001, 1.0, 400, 600));
			d.wait;
		};
		b release: 5;
	}.fork;
}.fork;
//:
a.release;

