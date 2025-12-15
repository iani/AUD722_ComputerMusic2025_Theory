2025-12-15 10:12
From ChatGpt:

In SuperCollider, **`doneAction`** is an integer argument used by many UGens (most commonly `EnvGen`, `Line`, `XLine`, `PlayBuf`, etc.) to specify **what the server should do when the UGen finishes**.

Below is the **complete, canonical list of `doneAction` values**, with **plain-language explanations**, typical use cases, and small notes about when _not_ to use them.

---

# `doneAction` Values (Authoritative List)

|Value|Action|What it Does|Typical Use|
|--:|---|---|---|
|**0**|**Do nothing**|UGen finishes, synth keeps running|Sustaining instruments, manual cleanup|
|**1**|Pause synth|Synth is paused (can be resumed)|Rare / experimental|
|**2**|**Free synth**|Entire Synth node is freed|Most common for envelopes|
|**3**|Free group|Frees the _parent group_ of the synth|Batch cleanup|
|**4**|Free enclosing group|Frees group enclosing this synth|Structured node trees|
|**5**|Free this and next synth|Frees this synth and the one after it|Advanced node ordering|
|**6**|Free this and previous synth|Frees this synth and the one before it|Advanced node ordering|
|**7**|Free all synths|Frees _all_ synths on the server|Emergency / reset|
|**8**|Free enclosing group and resume next|Group freed, next node resumes|Sequencing hacks|
|**9**|Free enclosing group and resume previous|Group freed, previous node resumes|Sequencing hacks|
|**10**|Free enclosing group and pause next|Group freed, next node paused|Rare|
|**11**|Free enclosing group and pause previous|Group freed, previous node paused|Rare|

---

# Most Common Values (You’ll Use These 99% of the Time)

## `doneAction: 0` — Do nothing

```supercollider
EnvGen.kr(Env.asr(...), gate);
```

- The synth continues running
    
- You must stop it manually
    
- Good for **long-lived instruments**
    

---

## `doneAction: 2` — Free the synth (⭐ standard)

```supercollider
EnvGen.kr(Env.perc(...), doneAction: 2);
```

- Synth is automatically freed
    
- Prevents node leaks
    
- **Default best practice** for one-shot sounds
    

> If you remember only one value: **2**

---

## `doneAction: 3 / 4` — Free groups

Used when:

- You spawn **multiple synths inside groups**
    
- You want **structured cleanup**
    

Example:

```supercollider
EnvGen.kr(env, doneAction: 4);
```

This frees the **enclosing group**, not just the synth.

---

# Subtle but Important Distinction

|Action|Scope|
|---|---|
|`2`|This synth only|
|`3`|Parent group|
|`4`|Enclosing group|

This matters in **node trees**, patterns, and **server-side sequencing**.

---

# Why `doneAction` Lives in UGens

- The **server**, not the language, decides when a UGen is “done”
    
- This avoids timing drift
    
- Crucial for envelopes, buffers, and automation
    

---

# Typical Envelope Patterns

### One-shot sound

```supercollider
EnvGen.kr(Env.perc(0.01, 0.3), doneAction: 2);
```

### Sustained instrument

```supercollider
EnvGen.kr(Env.adsr(...), gate, doneAction: 2);
```

(Synth frees only after release finishes.)

---

# Common Beginner Mistakes

1. Forgetting `doneAction: 2` → **node leak**
    
2. Using `doneAction` with a sustain envelope but **never closing the gate**
    
3. Using group-free actions without understanding node hierarchy
    
4. Expecting `doneAction` to trigger immediately (it triggers **after envelope completion**)
    

---

# Conceptual Summary

> **`doneAction` = what the server does when time-based control is finished**

- It is **not** a language-side callback
    
- It is **deterministic**
    
- It is **critical for clean audio graphs**
    

---

If you want next:

- A **node-tree diagram** explaining `doneAction 3–11`
    
- Practical **Patterns + doneAction** strategies
    
- How `doneAction` interacts with **`gate`, `legato`, and `\sustain`**
    
- A **live-coding safety checklist** (avoiding runaway nodes)
    

Just tell me.