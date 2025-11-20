# BallisticBulletSingletonEventPusher.gd
class_name BallisticBulletSingletonEventPusher
extends Node

@export var debug_last_pushed_fired_start :BallisticStructs.STRUCT_BallisticStartPoint
@export var debug_last_pushed_destroyed_start :BallisticStructs.STRUCT_BallisticStartPoint
@export var debug_last_pushed_destroyed_end :BallisticStructs.STRUCT_BallisticsEndPoint

## Push a bullet fired event
func notify_fired_bullet(start_point: BallisticStructs.STRUCT_BallisticStartPoint) -> void:
	BallisticStructs.copy_start_point(start_point, debug_last_pushed_fired_start)
	BallisticBulletSingletonEvent.from_global_trigger_bullet_fired(start_point)
	
## Push a bullet destroyed event
func notify_destroyed_bullet(
	start_point: BallisticStructs.STRUCT_BallisticStartPoint,
	end_point: BallisticStructs.STRUCT_BallisticsEndPoint
) -> void:
	BallisticStructs.copy_start_point(start_point, debug_last_pushed_destroyed_start)
	BallisticStructs.copy_end_point(end_point, debug_last_pushed_destroyed_end)
	BallisticBulletSingletonEvent.from_global_trigger_bullet_destroyed(start_point, end_point)
