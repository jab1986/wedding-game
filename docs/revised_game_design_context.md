# Revised Game Design Context

## Core Game Identity

**NOT a "wedding game"** - that's misleading terminology that doesn't capture the actual game concept.

**Actually**: A chaotic hub-based RPG with South Park + Celebrity Death Match + Pokemon aesthetic
- Wedding storyline is just ONE level in a larger absurdist adventure
- Constant frustration for players, over-the-top violence, dark humor, very random
- Intentionally chaotic and unpredictable gameplay experience

## Game Structure

**Main Hub**: Top-down RPG area (Pallet Town style) where players can interact
- Central exploration area for player movement and NPC interactions
- Gateway to accessing various mini-games and levels
- Serves as home base between challenges

**Multiple Mini-Games/Levels**: Accessible from hub with varying styles
- Each level can have completely different gameplay mechanics
- Mismatched genres intentionally for absurdist effect
- Progressive unlocking system - levels unlock as game progresses

**Endgame**: Boss fight and wedding ceremony finale

## Level Examples

- **Glen Bingo**: SimGangster style gameplay
- **Beat 'em up level**: Combat-focused action
- **Wedding storyline adventure**: Based on the character script
- **Other random challenges**: Various mismatched genres and mechanics

## Technical Architecture

**Engine**: Godot 4.4
**Key Addon**: DialogueManager for all story/character interactions

**File Structure**:
- `Main.tscn`: Hub world (top-down 2D exploration)
- `levels/` directory: Individual mini-games and challenges
- `components/` directory: Reusable elements and systems

## Characters from Wedding Script

**Main Characters**:
- **Mark & Jenny**: Main playable characters
- **Glen**: Chaos-creating father figure
- **Quinn**: Competent mother figure
- **Jack**: Hipster cafe owner
- **Acids Joe**: Final boss character

**Supporting Cast**: Various allies and enemies throughout the adventure

## Development Environment

**Platform**: Mobile-desktop hybrid via Termux
**Integration**: MCP integration with 18 overflow tools
**Workflow**: Git-based workflow with session management
**Working Directory**: `/home/joe/Projects/wedding-game`

## Key Design Principles

1. **Chaos Over Coherence**: Intentionally random and frustrating gameplay
2. **Genre Mixing**: Deliberately mismatched gameplay styles between levels
3. **Dark Humor**: South Park-style irreverent comedy
4. **Progressive Unlocking**: Structured progression despite chaotic content
5. **Hub-Based Exploration**: Central area connects all game elements

## Context Notes

This document serves as the definitive reference for the game's actual design philosophy and technical implementation. The "wedding game" terminology is a historical artifact from early development and does not accurately represent the final game concept.

Last Updated: 2025-07-07