# PROJECT_AUDIT

## Project
- Name: 侠客异闻录
- Repository: wordworld
- Engine: Godot 4.7.2 stable
- Language: GDScript
- Renderer: Compatibility
- Plugins: none

## Current implementation baseline
- Player movement: WASD + arrow keys
- Player: CharacterBody2D
- Player animation: 4-direction idle + 4-direction walk
- Formal player assets: integrated
- Player collision: CapsuleShape2D
- Camera: child of Player, limits 2400x1600
- Current development world: greybox

## Phase status
- Phase 1: runnable movement prototype — complete
- Phase 2: four-direction animation framework — complete
- Phase 3: greybox world and collision — complete
- Phase 4: formal player sprites — complete
- Phase 4.1: pixel cleanup of formal sprites — locally validated by user
- Phase 5 / Milestone 1: Village 01 greybox shell — in progress

## Milestone 1 target
The project specification requires the first village to contain:
- terrain
- buildings
- warehouse entrance / interaction
- NPC placeholders
- dungeon entrance
- basic UI
- player movement and collision

The current implementation intentionally starts with a greybox shell. It does not freeze the final village layout.

## Frozen constraints
- Do not alter the confirmed player character design.
- Do not replace or regenerate the formal player sprites.
- Do not change player movement, facing, collision or camera parameters unless a concrete test proves they are wrong.
- Do not implement combat, roguelike floor generation, enemies, items or economy in this milestone.
- Do not decide unresolved gameplay rules in code.

## Known unresolved design decisions
- Exact village layout and final building positions.
- Unified interaction key.
- Final interaction UI.
- Warehouse capacity and storage rules.
- Complete shop pricing.
- Final village art.

Those items remain provisional until explicitly designed.
