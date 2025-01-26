extends Node
@warning_ignore("unused_signal") signal SettingsChange; 
@warning_ignore("unused_signal") signal unpause;
@warning_ignore("unused_signal") signal screen_shake(strength:float, duration:float);
@warning_ignore("unused_signal") signal retarget(player_pos:Vector2);
@warning_ignore("unused_signal") signal spawn_root(node:Node2D);
@warning_ignore("unused_signal") signal spawn_primary();
@warning_ignore("unused_signal") signal ascend(teleportPoint:Vector2);
@warning_ignore("unused_signal") signal descend(teleportPoint:Vector2);
@warning_ignore("unused_signal") signal stair_exited();
@warning_ignore("unused_signal") signal teleport_player(location:Vector2)
@warning_ignore("unused_signal") signal shift_background_color(newColor:Color)
@warning_ignore("unused_signal") signal change_inventory_type(newType : String)
@warning_ignore("unused_signal") signal update_details_screen(objname : String)
@warning_ignore("unused_signal") signal start_combat_area(area_name : Arena.localeNames)
@warning_ignore("unused_signal") signal start_base

@warning_ignore("unused_signal") signal start_dialogue(name : String)
@warning_ignore("unused_signal") signal lock_move_camera(pos : Vector2)
@warning_ignore("unused_signal") signal unlock_move_camera()
@warning_ignore("unused_signal") signal dialogue_chunk_finished(name : String)
