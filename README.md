# pvp-revive


This script provides a customizable player revive system for FiveM servers. It detects when a player is dead or dying and offers a seamless interaction to self-revive using a progress-based system.


# Features:

*only work in bucket 0*/n
Automatically identifies when a player is dead or dying and triggers the revive interface.
Displays a text-based interface prompting the player to revive by pressing a key ([E] - Revive).
Temporary Invincibility: Players are invincible for a brief duration post-revival to prevent immediate harm.
Implements controls to disable weapon usage while invincible and prevents excessive melee actions during revival.

# Configuration Options:

Customize progress bar duration.
Modify UI styles (background color, text color, and position).
Adjust invincibility duration or disable features as needed.

# Dependencies:

ox_lib for UI elements and utility functions.
Compatible with ESX framework (esx_status event is used).

