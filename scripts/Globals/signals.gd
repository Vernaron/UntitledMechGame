extends Node

signal SettingsChange;
signal unpause;
signal screen_shake(strength:float, duration:float);
signal retarget(player_pos:Vector2);
signal spawn_root(node:Node2D);
signal spawn_primary();
signal ascend(teleportPoint:Vector2);
signal descend(teleportPoint:Vector2);
signal stair_exited();
signal teleport_player(location:Vector2)
signal shift_background_color(newColor:Color)
