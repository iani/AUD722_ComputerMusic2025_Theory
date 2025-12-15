
Here is a **concise but complete list of SuperCollider’s envelope shortcut / factory methods**, with **what they generate internally**, **whether they have a release node**, and **typical musical use**. This is meant as a **reference list** you can keep open while coding.

I’ll group them **by envelope logic**, not alphabetically, which is usually how one _thinks_ musically.

---

# 1. One-Shot Envelopes (NO release node)

These **run once and finish automatically**.

---

## `Env.perc`

```supercollider
Env.perc(attackTime = 0.01, releaseTime = 1.0, level = 1.0, curve = -4)
```

**Shape**

```
0 → level → 0
```

**Use**

- Percussion
    
- Plucks
    
- Grains
    
- Events in Patterns
    

---

## `Env.triangle`

```supercollider
Env.triangle(dur = 1.0, level = 1.0)
```

**Shape**

```
0 → level → 0
(equal rise/fall)
```

**Use**

- Simple modulation
    
- Neutral fades
    
- Symmetric gestures
    

---

## `Env.sine`

```supercollider
Env.sine(dur = 1.0, level = 1.0)
```

**Shape**

- Half sine wave (smooth in/out)
    

**Use**

- Natural-sounding fades
    
- Avoiding clicks
    
- Granular synthesis
    

---

## `Env.linen`

```supercollider
Env.linen(attackTime, sustainTime, releaseTime, level = 1.0, curve = 0)
```

**Shape**

```
0 → level → level → 0
```

**Use**

- Fixed-duration pads
    
- Drones with known length
    
- Phrase-shaped envelopes
    

---

## `Env.step`

```supercollider
Env.step(levels = [0, 1, 0], times = [0.5, 0.5])
```

**Shape**

- Stepped (no interpolation)
    

**Use**

- Sample & hold
    
- Rhythmic gating
    
- Control signals
    

---

# 2. Sustain Envelopes (WITH release node)

These **wait for a gate = 0** before releasing.

---

## `Env.asr` (Attack–Sustain–Release)

```supercollider
Env.asr(attackTime = 0.01, sustainLevel = 1.0, releaseTime = 1.0, curve = -4)
```

**Shape**

```
0 → sustain → (wait) → 0
```

**Use**

- Held tones
    
- Live coding instruments
    
- MOCAP / sensor control
    

---

## `Env.adsr` (Attack–Decay–Sustain–Release)

```supercollider
Env.adsr(
    attackTime = 0.01,
    decayTime = 0.3,
    sustainLevel = 0.5,
    releaseTime = 1.0,
    peakLevel = 1.0,
    curve = -4
)
```

**Shape**

```
0 → peak → sustain → (wait) → 0
```

**Use**

- Classic synth voices
    
- Keyboard-like articulation
    
- Filter envelopes
    

---

## `Env.dadsr` (Delay–Attack–Decay–Sustain–Release)

```supercollider
Env.dadsr(
    delayTime,
    attackTime,
    decayTime,
    sustainLevel,
    releaseTime,
    peakLevel = 1.0,
    curve = -4
)
```

**Adds**

- Initial delay before attack
    

**Use**

- Echo-like entries
    
- Phasing layers
    
- Staggered onsets
    

---

# 3. Looping / Repeating Envelopes

---

## `Env.circle`

```supercollider
Env.circle(
    levels = [0, 1, 0],
    times  = [1, 1],
    curve  = 0
)
```

**Behavior**

- Loops forever
    

**Use**

- LFOs
    
- Cyclic modulation
    
- Repeating gestures
    

---

# 4. Special-Purpose Envelope Constructors

---

## `Env.xyc`

```supercollider
Env.xyc(
    levels,
    times,
    curves
)
```

- Explicit control of curve **per segment**
    
- Shortcut for complex shapes
    

---

## `Env.pairs`

```supercollider
Env.pairs([
    [0, 0],
    [1, 0.2],
    [0.3, 0.6],
    [0, 0.2]
], curve: -4)
```

- Each pair = `[level, time]`
    
- Readable for hand-coded shapes
    

---

# 5. Comparison Table

|Method|Release Node|Typical Use|
|---|---|---|
|`perc`|❌|Percussion, grains|
|`triangle`|❌|Symmetric gestures|
|`sine`|❌|Smooth fades|
|`linen`|❌|Fixed pads|
|`step`|❌|Discrete control|
|`asr`|✅|Held tones|
|`adsr`|✅|Instruments|
|`dadsr`|✅|Delayed entries|
|`circle`|♻|LFOs|
|`pairs`|depends|Custom shapes|
|`xyc`|depends|Advanced shaping|

---

# 6. Practical Tip (Live Coding)

For live coding and instruments, a **canonical pattern** is:

```supercollider
EnvGen.kr(Env.adsr(...), gate, doneAction: 2)
```

For patterns and events:

```supercollider
EnvGen.kr(Env.perc(...), doneAction: 2)
```

---

If you want next, I can:

- Show **how each shortcut expands internally to `Env.new`**
    
- Give a **musician’s cheat-sheet** (pluck, breath, bow, swell)
    
- Connect envelope types to **Patterns (`Pbind`, `\legato`)**
    
- Show **non-amplitude uses** (FM, spatialization, timbre morphing)
    

Just say the word.