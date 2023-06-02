# Fighting Game

## 📃 About:
This is a fighting game made in the [Godot Engine](https://godotengine.org/) using GDScript.

## 🎮 Controls:
### Player 1
* W/Space = Up
* S = Down
* A = Left
* D = Right
* H = Light Move
* U = Medium Move
* I = Heavy Move
* O = Special Command
### Player 2
* Arrow Keys = Up, Down, Left, Right
* Numpad 1 = Light Move
* Numpad 4 = Medium Move
* Numpad 5 = Heavy Move
* Numpad 6 = Special Command
### Controller (PS4)
* Left Stick / DPad = Up, Down, Left, Right
* Square = Light Move
* Cross = Medium Move
* Triangle = Heavy Move
* Circle = Special Command

## 📖 Features:
* Both players have Resources: Health, Barrier, and Special Meter
    * Health is the player's main resource to manage. If it fully depletes, the player loses.
    * Barrier is a resource that allows the player to block attacks. This bar absorbs the damage whenever the player blocks. When depleted, they will not be able to block for a long time.
    * Special Meter is spent by using Heavy Moves, Special Finishers or Burst. These moves can only be used depending on the current level of the special meter.
* Special Commands execute different Special Moves depending on the direction they are holding
* Special Moves can be executed using Motion Inputs

## Moves:
* Grab (L & M at the same time)
* Burst (L, M, H at the same time)
    * Requires 100% of meter
    * Only works when in hitstun or blockstun
* Fireball (236L/M/H, S)
    * Spawns a projectile
    * Projectiles have more hits when using the medium or heavy version
* Spin-kick (214M/H, 4S)
    * Moves the player horizontally
    * Multi-hit attack
    * Heavy version moves diagonally
* Dragon Punch (623M/H, 3S)
    * Anti-air attack
    * Invincible for 5 frames on startup
    * Heavy version rises further and deals more damage
* Buster Grab (632146L/S)
    * Command Grab
    * Deals a lot of damage
    * Special version only works when enemy is below half health
    * Special version is a finisher move and instantly KOs the enemy

## 📑 Credits:
* [Font Resources](pentacom.jp)