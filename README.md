# 🔦 LAMPHEAD — Core Gameplay Systems

A cosmic-horror endless runner built in **Godot 4.4**, focused entirely on a tense, mathematically decaying resource loop. This repository contains the standalone structural scripts, state machines, and core logic governing the game's mechanics.

## 🕹️ System Architecture Overview

The game revolves around **two primary interconnected loops**: short-term survival (immediate light resource) versus long-term decay (maximum capacity degradation). 

---

## LAMPHEAD on Itch.io

👉 **[Click here to see the game on Itch.io!](https://trakr21.itch.io/lamphead)**

---

## 🛠️ Core Gameplay Systems (Script Architecture)

### 1. The Lamphead Controller (`Player` & `Light` Subsystems)
* **Player Script:** Handles physics-based movement, 2D collisions, and world interactions.
* **Light Script (Dual-Resource Pattern):** 
  * **Battery:** Drains continuously over time. The current battery percentage dynamically scales the light's radius and brightness. At `0`, the light turns off.
  * **Light Health (Max Capacity):** Represents the permanent wear on the bulb. 
  * **The Tension Loop:** Picking up a battery restores *current* charge but permanently *decreases* Light Health (shrinking the maximum capacity). Picking up **Screws** is the exclusive mechanic to repair Light Health and expand the ceiling again.

### 2. Manual Light Toggle (Risk / Reward State)
* **Light ON:** Consumes battery continuously. Keeps the entity in a standard, manageable state.
* **Light OFF:** Freezes battery consumption entirely but immediately triggers severe environmental threats.

### 3. Progressive Procedural Generation (`Endless Rooms`)
* **Room Instantiation:** Utilizes a pool of fixed room scene templates, randomly stitching them together sequentially to create an infinite, looping layout.
* **Scoring Logic:** Player progress is tracked linearly where `Total Rooms Cleared = High Score`.

### 4. Dynamic Probability Matrix (Item Progression Curve)
To enforce a natural difficulty curve and inevitable "death spiral," item spawn tables shift dynamically per room:
* **Baseline (Room 1):** 50% chance per table to spawn an item (Split evenly: 50% Battery / 50% Screw).
* **Progression Modifier:** Every sequential room increases Battery probability by `+X%` and decreases Screw probability by `-X%`.
* **Late Game:** Screws eventually hit a `0%` spawn threshold. The world stops spawning healing items entirely, forcing a systemic breakdown where players must survive purely on temporary battery patches.

### 5. Finite State Machine: The Monster
The hostile AI tracks the player's status properties globally to transition between two highly distinct behavior states:

| AI State | Activation Triggers | Behavior Metrics |
| :--- | :--- | :--- |
| **Normal Mode** | Battery > 0 **AND** Light Health > 0 **AND** Light is ON | 1.0x Base Speed, standard damage, passive routing. |
| **Aggro Mode** | Battery == 0 **OR** Light Health == 0 **OR** Light is OFF | Hyper-aggressive tracking, amplified movement speed, high damage multipliers. |

### 6. Cosmic Horror Lore Elements
* Procedural placement algorithms select randomized spawn hooks inside rooms.
* Employs a strict singleton check ensuring each specific environmental narrative element instantiates exactly once per run.

### 7. Win / Loss Evaluation
* **Death Condition:** Triggered immediately if the Monster deals a damage causing the player's `Light Health == 0`.

---

## 📂 Repository File Guide
*(Review the individual architectural design blocks directly in the root directory)*:

- **Core Loop & State Management:** `main.gd`, `globals.gd`
- **Player Controller & Input:** `player.gd`, `CameraController.gd`
- **Light & Resource Systems:** `LightManager.gd`, `Mouselighting.gd`
- **Enemy AI State Machine:** `monster.gd`
- **World & Map Procedural Gen:** `room.gd`, `RoomManager.gd`, `TableActivation.gd`
- **Game Progression & HUD UI:** `PickupLogic.gd`, `UI.gd`, `RoomsSurvived.gd`, `gameOverScreen.gd`
---

## 📄 License
This project's code and `.gd` scripts are licensed under the **MIT License**. Feel free to explore, clone, or review the structural logic.
