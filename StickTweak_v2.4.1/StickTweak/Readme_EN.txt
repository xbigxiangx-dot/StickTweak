StickTweak Readme
=================

## Basic Information

- Version: v2.4.0
- Requirement: StickLuaFunctions v0.9.x-Alpha must be installed first. Other Alpha versions are not guaranteed to be compatible.

## Main Features

Creature Tweaks
---------------

- Trolls and other regenerating creatures fall down immediately at low HP.


Item Tweaks
-----------

- Items that increase movement speed are compatible with Free Action effects.
- Items with Free Action effects are compatible with Haste effects.


Spell Tweaks
------------

- True Sight-type spells take effect once per second.
- Blade Barrier-type spells take effect once per second; they also trigger once more when a creature enters or leaves the spell area.
- Defensive Harmony grants AC bonuses based on the number of nearby party members.
- Free Action and Haste effects are compatible.
- When a sequencer is cast on another target or on the ground, self-targeted spells stored in the sequencer still correctly affect the caster.
- Fire Shield-type spells correctly trigger their counterattack effect even when the attacker misses.


Weapon Style Rebalance
----------------------

- Two-Handed Weapon Style gains new effects:
  - 1 slot: attack and damage rolls gain an additional 0.5x Strength adjustment bonus. Killing an enemy triggers Cleave, making one physical attack against another nearby enemy.
  - 2 slots: if Cleave kills an enemy, it triggers Cleave again.

- Single-Weapon Style gains new effects:
  - 1 slot: when using a light weapon, attack rolls use the higher of the Dexterity and Strength adjustments. If the character has at least 1 slot in the relevant weapon proficiency, damage rolls can receive the same benefit.

- Single-Weapon / Two-Handed style switching:
  - When a character has a one-handed weapon equipped in the main hand and nothing equipped in the off hand, the character can choose whether to use Single-Weapon Style or Two-Handed Weapon Style.

- Two-Weapon Style gains new effects:
  - When a light weapon is equipped in the off hand, two-weapon attack penalties are reduced. This takes effect starting at 0 slots in Two-Weapon Style:
    - 0 slots: attack penalties become -2/-4.
    - 1 slot: attack penalties become 0/-2, and the Dexterity adjustment can be used to offset attack penalties.
    - 2 slots: attack penalties become 0/0.
  - At 3 slots in Two-Weapon Style, the off-hand weapon benefits from attacks-per-round bonuses granted by the relevant weapon proficiency.


Miscellaneous Tweaks
--------------------

- In EET, equipment is inherited when transitioning from SOD to SOA. It is placed in the container near Ilyich in the starting dungeon.
- In EET, gold is inherited when transitioning from SOD to SOA. It is placed on Mae'Var.
- Paladins can inherit de'Arnise Keep; if the protagonist's THAC0 is below 11, any class can inherit it.
