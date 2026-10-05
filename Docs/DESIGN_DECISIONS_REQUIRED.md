# DESIGN_DECISIONS_REQUIRED

## 001 — Village interaction key and UI

### Problem
Milestone 1 requires warehouse entrance / interaction and later NPC, shop, martial arts school and dungeon entrance interactions.

### Existing evidence
The design documents define the existence and role of village facilities, but do not lock a universal interaction key or final interaction UI.

### Why this cannot be safely inferred
Choosing an input key and interaction presentation changes the player-facing control scheme and UI architecture.

### Current action
Do not hard-code a final interaction key or final interaction UI in the greybox.

### Technical preparation
The Village 01 greybox exposes stable Marker2D locations for the future functional points. Interaction code can be added after the control/UI decision is explicitly made.

## 002 — Exact Village 01 layout

### Problem
The first village is required, but exact building coordinates and final visual arrangement are not locked.

### Current action
Use a clearly provisional greybox arrangement only for technical validation. Treat all positions as replaceable.
