
2025-12-15 09:36

---

---

Below is a **structured, progressive introduction to Envelopes in SuperCollider**, aimed at **beginners → intermediate users**, with a clear distinction between **envelopes without a release node** and **envelopes with a release node**. I’ll keep the examples minimal but idiomatic, and I’ll point out _why_ and _when_ you’d choose each type—important for composition and live coding contexts you often work in.

---

## 1. What is an Envelope in SuperCollider?

An **envelope** describes how a parameter changes over time. Most commonly it controls:

- **Amplitude** (loudness over time)
    
- **Frequency**
    
- **Filter cutoff**
    
- **Any continuous control signal**
    

In SuperCollider, envelopes are:

- Defined on the **language side** using the `Env` class
    
- Executed on the **server** using envelope UGens like:
    
    - `EnvGen`
        
    - `IEnvGen` (for special cases)
        

---

## 2. Basic Envelope Components

An envelope consists of:

1. **Levels** (values)
    
2. **Times** (durations between levels)
    
3. **Curves** (shape of transitions)
    

Conceptually:

```
level[0] --time[0]--> level[1] --time[1]--> level[2] ...
```

---

## 3. The Simplest Envelope: Env.perc (No Release Node)

### Example: Percussive Envelope

```supercollider
Env.perc(attackTime: 0.01, releaseTime: 0.3)
```

This creates:

- A quick rise
    
- A natural decay
    
- **No sustain**
    
- **No external release control**
    

### Using it in a SynthDef

```supercollider
SynthDef(\percTone, {
    |freq = 440|
    var env = EnvGen.kr(
        Env.perc(0.01, 0.3),
        doneAction: 2
    );
    var sig = SinOsc.ar(freq) * env;
    Out.ar(0, sig.dup);
}).add;
```

```supercollider
Synth(\percTone);
```

### Key Points

- The envelope **runs once and finishes**
    
- `doneAction: 2` frees the synth automatically
    
- Ideal for:
    
    - Drum sounds
        
    - Plucked sounds
        
    - Short gestures
        

---

## 4. Explicit Envelope: Env.new (Still No Release Node)

You can define envelopes explicitly:

```supercollider
Env(
    levels: [0, 1, 0.5, 0],
    times:  [0.01, 0.2, 0.4],
    curve:  -4
)
```

### Example Synth

```supercollider
SynthDef(\shapeTone, {
    var env = EnvGen.kr(
        Env([0, 1, 0.5, 0], [0.01, 0.2, 0.4], -4),
        doneAction: 2
    );
    Out.ar(0, Saw.ar(200) * env ! 2);
}).add;
```

### Use When

- The sound has a **fixed duration**
    
- You want total control over shape
    
- No need for live release
    

---

## 5. Envelopes with a Release Node (ASR / ADSR)

Now we introduce **sustain** and **release control**.

---

## 6. Env.asr – Attack / Sustain / Release

```supercollider
Env.asr(
    attackTime: 0.01,
    sustainLevel: 1.0,
    releaseTime: 0.3
)
```

This envelope:

- Rises to sustain
    
- **Waits**
    
- Releases when `gate` goes from 1 → 0
    

---

## 7. Using Gate-Controlled Envelopes

### Important: `gate`

- `gate = 1` → envelope sustains
    
- `gate = 0` → envelope releases
    

### Example SynthDef

```supercollider
SynthDef(\asrTone, {
    |freq = 440, gate = 1|
    var env = EnvGen.kr(
        Env.asr(0.01, 1, 0.3),
        gate,
        doneAction: 2
    );
    Out.ar(0, SinOsc.ar(freq) * env ! 2);
}).add;
```

### Play and Release

```supercollider
x = Synth(\asrTone);
x.set(\gate, 0);
```

### Key Difference

- The envelope **does not end by itself**
    
- You decide when the sound stops
    

---

## 8. Env.adsr – The Classic Envelope

```supercollider
Env.adsr(
    attackTime: 0.01,
    decayTime: 0.2,
    sustainLevel: 0.6,
    releaseTime: 0.4
)
```

### Example

```supercollider
SynthDef(\adsrTone, {
    |freq = 440, gate = 1|
    var env = EnvGen.kr(
        Env.adsr(0.01, 0.2, 0.6, 0.4),
        gate,
        doneAction: 2
    );
    Out.ar(0, Pulse.ar(freq, 0.5) * env ! 2);
}).add;
```

```supercollider
x = Synth(\adsrTone);
x.set(\gate, 0);
```

---

## 9. Why “Release Node” Matters

### Without Release Node

- Envelope runs once
    
- Time is predetermined
    
- No interaction
    

### With Release Node

- Envelope waits indefinitely
    
- External control via `gate`
    
- Essential for:
    
    - Keyboard instruments
        
    - Live coding
        
    - Interactive systems
        
    - MOCAP / sensor control
        

---

## 10. Visualizing Envelopes (Highly Recommended)

```supercollider
Env.adsr(0.01, 0.2, 0.6, 0.4).plot;
Env.perc(0.01, 0.3).plot;
```

This is crucial for developing _intuition_.

---

## 11. Advanced: Custom Release Node in Env.new

You can specify **where the release happens**:

```supercollider
Env(
    levels: [0, 1, 0.7, 0],
    times:  [0.01, 0.3, 0.5],
    releaseNode: 1
)
```

- The envelope sustains at `levels[1]`
    
- Release jumps to segment starting at index 1
    

Used for **non-standard ADSR shapes**.

---

## 12. Control-Rate vs Audio-Rate Envelopes

- `EnvGen.kr` → amplitude, filters, parameters
    
- `EnvGen.ar` → FM, waveshaping, audio modulation
    

Example:

```supercollider
SinOsc.ar(200 + EnvGen.ar(Env.perc(0.01, 0.2)) * 400)
```

---

## 13. Common Beginner Mistakes

1. Forgetting `doneAction: 2`
    
2. Using `Env.adsr` **without a gate**
    
3. Expecting a sustain envelope to end automatically
    
4. Using `EnvGen.ar` unnecessarily
    
5. Confusing `releaseTime` with `decayTime`
    

---

## 14. Conceptual Summary

|Type|Gate?|Ends Automatically?|Use Case|
|---|---|---|---|
|`Env.perc`|❌|✅|One-shot sounds|
|`Env.new` (no release)|❌|✅|Fixed gestures|
|`Env.asr`|✅|❌|Held notes|
|`Env.adsr`|✅|❌|Instruments|

---

If you want, next we can:

- Design **musical envelope archetypes** (pluck, bow, breath, swarm)
    
- Explore **multi-parameter envelopes** (amp + filter + pitch)
    
- Integrate envelopes into **Patterns (Pbind)**
    
- Discuss envelopes as **formal structures** in long-duration works (very relevant to _From Microsound to Macrosound_)
    

Just tell me how you’d like to continue.