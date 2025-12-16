
---

*Do you know after  pattern or class in another system served as model for the design of the class NotificationCenter in SuperCollider?*

---

Short answer: **yes — it is very clearly modeled on the Smalltalk / NeXTSTEP–Cocoa notification + controller tradition**, combining **MVC “Controller”** ideas with the **Observer (publish–subscribe) pattern**.

Below is the precise lineage.

---

## 1. The primary model: **Smalltalk-80 MVC**

SuperCollider’s class library is deeply influenced by **Smalltalk-80**, and `NotificationCenter` fits squarely into that tradition.

In classic **Smalltalk MVC**:

- **Model** holds state
    
- **View** displays
    
- **Controller** mediates interactions and _listens_ for changes
    

Smalltalk models commonly implement **dependency / change notification**, where interested objects register themselves to be notified when something changes.

➡️ `NotificationCenter` plays exactly this mediating role:

- It **registers interest**
    
- It **forwards notifications**
    
- It **decouples sender and receiver**
    

This is _textbook Smalltalk MVC controller behavior_.

---

## 2. The design pattern: **Observer (Publish–Subscribe)**

From a GoF (Gang of Four) point of view, the underlying pattern is:

> **Observer pattern**

Key characteristics shared with `NotificationCenter`:

- Subjects do **not know** who observes them
    
- Observers register interest dynamically
    
- Notifications are broadcast, not directly invoked
    
- Loose coupling is preserved
    

In SuperCollider:

- The **model** emits a notification
    
- `NotificationCenter` manages the observer list
    
- Observers receive callbacks
    

So conceptually:

```
Subject  →  NotificationCenter  →  Observers
```

---

## 3. Very strong influence: **NeXTSTEP / Cocoa (`NSNotificationCenter`)**

There is also a _very direct conceptual parallel_ with:

- **NeXTSTEP / Cocoa**
    
- `NSNotificationCenter`
    

Cocoa’s design:

- Centralized notification hub
    
- Objects register for named notifications
    
- No direct references between sender and receiver
    

SuperCollider differs in implementation details, but the _idea_ is extremely close:

|Cocoa|SuperCollider|
|---|---|
|`NSNotificationCenter`|`NotificationCenter`|
|`addObserver:selector:`|`addDependant` / notify|
|Decoupled objects|Decoupled objects|

This is not accidental:  
**James McCartney has explicitly acknowledged Smalltalk and NeXT influences** in SC’s object system and event architecture.

---

## 4. Why a _Controller_ and not just a _NotificationCenter_?

This is a subtle but important SC design choice.

In SuperCollider:

- Notifications are often **attached to specific objects**
    
- The controller mediates **lifecycle and ownership**
    
- It fits SC’s **object-centric**, not global, philosophy
    

So `NotificationCenter` is:

- Less global than Cocoa’s `NSNotificationCenter`
    
- More tightly integrated into object identity
    
- More idiomatic Smalltalk
    

---

## 5. Conceptual summary

`NotificationCenter` is best understood as:

> **A Smalltalk-style MVC Controller implementing the Observer pattern, strongly influenced by NeXTSTEP/Cocoa notification architecture, adapted to SuperCollider’s object model.**

If you want, next we can:

- Trace **how `dependants` and `changed` relate**
    
- Compare `NotificationCenter` vs `SimpleController`
    
- Or map this directly onto **event systems in Max, Pd, or JavaScript**
    

Just say the word.

---
*Tell me how this maps onto event systems in Max and Pd*

---

This is a very good question, because it exposes a **deep philosophical difference** between SuperCollider and the Max / Pd lineage — even though, on the surface, all three are “event-driven”.

I’ll map this carefully, structurally rather than cosmetically.

---

## 1. SuperCollider vs Max/Pd: what _counts_ as an event?

### SuperCollider

An **event** is:

- an **object-level semantic change**
    
- propagated via **observer relationships**
    
- independent of time, scheduling, or signal flow
    

Example:

```supercollider
obj.changed(\value, newValue);
```

This is:

- _symbolic_
    
- _typed_
    
- _decoupled from execution order_
    

---

### Max / Pd

An **event** is:

- a **message arriving at an inlet**
    
- propagated via **explicit patch-cord topology**
    
- executed **immediately and deterministically**
    

Example (conceptual):

```
[number box] → [route value]
```

This is:

- _procedural_
    
- _positional_
    
- _graph-ordered_
    

---

## 2. NotificationCenter ↔ Max/Pd message fan-out

### SuperCollider

```
Object
   |
changed(...)
   |
NotificationCenter
   |
multiple observers
```

- Observers are **registered dynamically**
    
- The sender **does not know** the receivers
    

---

### Max / Pd

```
[message source]
      |
    [t b l]
      |
   multiple patch cords
```

- Receivers are **hard-wired**
    
- Fan-out is **explicit**
    
- Order is **defined by wiring and trigger objects**
    

➡️ **Key difference**  
In Max/Pd, _fan-out is a spatial decision_.  
In SC, _fan-out is a semantic relationship_.

---

## 3. Observer pattern vs patch cords

|Concept|SuperCollider|Max / Pd|
|---|---|---|
|Observer registration|`addDependant`|draw a patch cord|
|Notification|`changed(\what, data)`|message|
|Dispatch|symbolic|positional|
|Coupling|loose|tight|
|Topology|invisible / dynamic|explicit / static|

Max/Pd **does not have** an observer abstraction; it has **signal routing**.

---

## 4. NotificationCenter vs `[send]/[receive]`

The closest Max/Pd analogue to `NotificationCenter` is:

- **Max**: `[send]/[receive]`, `[forward]`
    
- **Pd**: `[send]/[receive]`, `[throw]/[catch]`
    

### Similarity

- Sender doesn’t know receivers
    
- Name-based routing
    
- Multiple receivers possible
    

### Crucial differences

|Aspect|SC NotificationCenter|Max/Pd send/receive|
|---|---|---|
|Scope|object-local|global namespace|
|Identity|object reference|symbol/string|
|Lifecycle|garbage-collected|manual discipline|
|Type safety|symbolic + object|typeless messages|

So `[send foo]` ≈ **very crude global NotificationCenter**, not a controller.

---

## 5. Time and scheduling (critical difference)

### SuperCollider

- Notifications are **not inherently timed**
    
- They can trigger scheduled actions, but do not _imply_ time
    
- Works cleanly with:
    
    - non-realtime logic
        
    - server lifecycle events
        
    - state changes
        

### Max / Pd

- Every message **happens now**
    
- Temporal control must be explicit:
    
    - `[delay]`
        
    - `[metro]`
        
    - `[pipe]`
        

➡️ Max/Pd events are **imperative**  
➡️ SC notifications are **declarative**

---

## 6. MVC thinking vs dataflow thinking

### SuperCollider

- Inherits **Smalltalk MVC**
    
- Separation between:
    
    - model state
        
    - observers
        
    - actions
        
- `NotificationCenter` lives in the **Controller** role
    

### Max / Pd

- Inherits **dataflow / control-rate DSP graphs**
    
- No MVC separation
    
- Patch _is_ the controller
    

This is why SC can cleanly express things like:

- “when this object’s state changes”
    
- “when the server boots”
    
- “when this buffer finishes loading”
    

…while Max/Pd needs **procedural scaffolding**.

---

## 7. Mapping table (concise)

|SuperCollider|Max|Pd|
|---|---|---|
|`NotificationCenter`|none (closest: `send/receive`)|none|
|Observer pattern|not present|not present|
|`addDependant`|draw cable|draw cable|
|`changed(\event)`|message|message|
|Semantic events|rare|rare|
|Global events|possible but discouraged|common|

---

## 8. Why this matters artistically (important)

For someone like you (live coding, networked systems, sensor fusion):

- **SC** encourages:
    
    - _semantic thinking_
        
    - modular reconfiguration
        
    - invisible but meaningful relationships
        
- **Max/Pd** encourages:
    
    - _diagrammatic thinking_
        
    - explicit control
        
    - performative immediacy
        

Neither is “better” — but `NotificationCenter` is **fundamentally alien** to Max/Pd’s worldview.

---

### One-sentence synthesis

> **NotificationCenter in SuperCollider expresses “something changed” as a semantic fact, whereas Max/Pd express “do this now” as a procedural action.**

If you want, next we could:

- map this to **Reactive programming**
    
- map it to **FRP vs dataflow**
    
- or trace how this affects _networked live coding architectures_
    

Just tell me where to go next.