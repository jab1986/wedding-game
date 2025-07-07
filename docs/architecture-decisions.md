# Wedding Game Architecture Decisions

## 1. Scene Organization Strategy

### Question: Single scene with multiple states vs. multiple scenes with transitions?

**Option A: Single Scene Architecture**
```
Main.tscn
├── GameWorld (Node2D)
├── UI Layer (CanvasLayer)
├── Audio (AudioStreamPlayer2D)
└── GameManager (manages states)
```

**Pros:**
- Faster transitions (no scene loading)
- Easier state sharing between game phases
- Better for continuous wedding chaos events
- Simpler memory management

**Cons:**
- Larger single scene complexity
- All assets loaded at once
- Harder to modularize development

**Option B: Multiple Scene Architecture**
```
Main.tscn (menu)
├── WeddingCeremony.tscn
├── Reception.tscn
├── Kitchen.tscn
├── Garden.tscn
└── BossArena.tscn (Acids Joe)
```

**Pros:**
- Modular development (team can work on different areas)
- Memory efficient (load only needed assets)
- Clear separation of concerns
- Easier to add new wedding venues

**Cons:**
- Loading transitions
- State persistence complexity
- Asset duplication possible

**RECOMMENDATION: Hybrid Approach**
- Main wedding venue as single scene
- Separate scenes for distinct areas (ceremony, reception, kitchen)
- Use StateMachine.gd for in-scene state management
- GameManager.gd for scene transitions

## 2. Character AI Complexity

### Question: Simple state machines vs. full behavior trees?

**Current Foundation:**
- StateMachine.gd already implemented
- Character configs in SpriteManager.gd
- 6 distinct characters with unique personalities

**Option A: Simple State Machines (RECOMMENDED)**
```gdscript
# Mark (Drummer) States
- idle
- walk  
- drumstick_attack
- rage_mode (when wedding chaos peaks)
```

**Pros:**
- Leverages existing StateMachine.gd
- Easier to debug and modify
- Performance efficient
- Adequate for wedding game scope

**Option B: Behavior Trees**
```
Mark Behavior Tree:
├── Sequence: Check Chaos Level
├── Selector: Choose Action
│   ├── Attack if enemies near
│   ├── Move toward chaos source
│   └── Idle drumming
```

**Pros:**
- More sophisticated AI
- Better for complex decision making
- Scalable for future features

**Cons:**
- Requires additional framework
- Overkill for wedding game scope
- More development time

**DECISION: Enhanced State Machines**
- Use StateMachine.gd as base
- Add context awareness (chaos level, nearby characters)
- Character-specific state extensions
- Keep it simple but responsive

## 3. Wedding Chaos System Design

### Question: What's the core gameplay loop?

**Core Concept: Escalating Wedding Chaos**

```
Chaos Level: 0 -----------> 100
           Peaceful    Complete Disaster

Events trigger based on chaos level:
- 0-20: Minor mishaps (spilled drinks)
- 21-40: Moderate problems (music issues) 
- 41-60: Major incidents (cake disaster)
- 61-80: Multiple simultaneous crises
- 81-100: Acids Joe boss fight
```

**Gameplay Loop Options:**

**Option A: Time Pressure Management**
- Wedding ceremony has time limit
- Chaos events spawn randomly
- Players must manage/fix chaos to prevent escalation
- Success = keeping chaos under control until "I do"

**Option B: Resource Management**
- Limited "organization points" (Quinn's specialty)
- Spend resources to fix chaos
- Earn resources by completing mini-tasks
- Balancing act between fixing and preventing

**Option C: Cooperative Action Game**
- Each character has unique abilities
- Players switch between characters
- Real-time action with strategic character selection
- Team coordination to handle multiple chaos sources

**RECOMMENDATION: Hybrid Time/Action System**
- Real-time wedding ceremony countdown
- Chaos events spawn based on time + random factors
- Character switching for different abilities
- Success measured by chaos level at key wedding moments

## 4. Technical Deployment Strategy

### Question: Mobile-first vs. desktop-first development?

**Current Constraints:**
- Godot project setup for desktop (1920x1080)
- Mobile development via Termux (no Godot editor)
- Need cross-platform compatibility

**Development Strategy:**
1. **Desktop-first development** (Godot editor required)
2. **Mobile adaptation** (responsive design, touch controls)
3. **Cross-platform testing**

**Mobile Considerations:**
- Touch input mapping (already planned in project.godot)
- UI scaling for different screen sizes
- Performance optimization for mobile hardware
- Battery usage optimization

**DECISION: Desktop-first with mobile-ready design**
- Develop primarily on desktop with Godot editor
- Design UI/UX for touch from the start
- Test on mobile regularly
- Use Termux for GDScript logic development

## 5. Asset Creation Strategy

### Question: AI-generated vs. placeholder vs. free assets?

**Options Analysis:**

**Option A: AI-Generated Sprites**
- Use MCP servers for sprite generation
- Consistent art style
- Custom wedding-themed assets
- Generated placeholder → final art pipeline

**Option B: Placeholder Development**
- Use SpriteManager's placeholder system
- Focus on gameplay mechanics first
- Replace with final art later
- Faster initial development

**Option C: Free/Open Assets**
- Use existing game assets
- Faster development
- Potential style inconsistency
- Licensing considerations

**RECOMMENDATION: Phased Approach**
1. **Phase 1**: Enhanced placeholders (current SpriteManager system)
2. **Phase 2**: AI-generated character sprites using MCP
3. **Phase 3**: Professional asset polish (if needed)

## 6. Save/Load System Requirements

### Question: What data needs persistence?

**Wedding Game State:**
- Current chaos level
- Character positions and states
- Wedding progress (ceremony completion %)
- Player statistics (fixes completed, time remaining)
- Unlocked areas/characters

**Save System Design:**
```gdscript
# GameManager.gd responsibility
var game_state = {
    "chaos_level": 45,
    "wedding_progress": 78,
    "characters": {
        "mark": {"position": Vector2(100, 200), "state": "drumstick_attack"},
        "jenny": {"position": Vector2(150, 180), "state": "photo"}
    },
    "current_scene": "reception",
    "time_remaining": 120.5
}
```

**DECISION: Simple JSON save system**
- Single save slot for wedding game
- Auto-save at key moments
- Manual save option in pause menu
- Quick restart for failed weddings

## Architecture Summary

**Chosen Architecture:**
1. **Hybrid scene organization** - Main wedding + separate venue scenes
2. **Enhanced state machines** - Extend StateMachine.gd with context
3. **Time/Action chaos system** - Real-time with character switching
4. **Desktop-first development** - Mobile-ready design
5. **Phased asset creation** - Placeholders → AI → Polish
6. **Simple save system** - JSON-based game state

**Next Implementation Steps:**
1. Create GameManager.gd with scene management
2. Create AudioManager.gd for wedding ambiance  
3. Design Main.tscn with modular areas
4. Implement chaos level system
5. Add character behavior contexts to StateMachine
6. Create placeholder wedding venue scenes

This architecture balances scope, development speed, and the unique chaotic wedding theme while leveraging existing code foundation.