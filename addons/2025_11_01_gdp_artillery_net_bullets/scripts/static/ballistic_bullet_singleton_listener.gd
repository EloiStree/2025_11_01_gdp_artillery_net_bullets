# BallisticBulletSingletonEventListener.gd
class_name BallisticBulletSingletonEventListener
extends Node


signal on_bullet_fired(fired_start_point: BallisticStructs.STRUCT_BallisticStartPoint)
signal on_bullet_destroyed(
	fired_start_point: BallisticStructs.STRUCT_BallisticStartPoint,
	destroyed_end_point: BallisticStructs.STRUCT_BallisticsEndPoint
)


@export var debug_last_received_fired_start :BallisticStructs.STRUCT_BallisticStartPoint
@export var debug_last_received_destroyed_start :BallisticStructs.STRUCT_BallisticStartPoint
@export var debug_last_received_destoyed_end :BallisticStructs.STRUCT_BallisticsEndPoint
# Signals


func _ready() -> void:
	connect_to_events()

func _exit_tree() -> void:
	disconnect_from_events()

func connect_to_events() -> void:
	BallisticBulletSingletonEvent.add_listener_start_bullet(_on_bullet_fired_internal)
	BallisticBulletSingletonEvent.add_listener_end_bullet(_on_bullet_destroyed_internal)

func disconnect_from_events() -> void:
	if not BallisticBulletSingletonEvent:
		return

	BallisticBulletSingletonEvent.remove_listener_start_bullet(_on_bullet_fired_internal)
	BallisticBulletSingletonEvent.remove_listener_end_bullet(_on_bullet_destroyed_internal)

# Internal wrappers to allow overriding
func _on_bullet_fired_internal(start_point: BallisticStructs.STRUCT_BallisticStartPoint) -> void:
	BallisticStructs.copy_start_point(start_point, debug_last_received_fired_start)
	on_bullet_fired.emit(start_point)

func _on_bullet_destroyed_internal(
	start_point: BallisticStructs.STRUCT_BallisticStartPoint,
	end_point: BallisticStructs.STRUCT_BallisticsEndPoint
) -> void:
	BallisticStructs.copy_start_point(start_point, debug_last_received_destroyed_start)
	BallisticStructs.copy_end_point(end_point, debug_last_received_destoyed_end)
	on_bullet_destroyed.emit(start_point, end_point)
	
func print_bullet_fired_internal(start_point: BallisticStructs.STRUCT_BallisticStartPoint) -> void:
	var str_build = "Bullet Fired: " + str(start_point)
	print(str_build)		

func print_bullet_destroyed_internal(
	start_point: BallisticStructs.STRUCT_BallisticStartPoint,
	end_point: BallisticStructs.STRUCT_BallisticsEndPoint
) -> void:
	var str_build = "Bullet Destroyed - Start: " + str(start_point) + ", End: " + str(end_point)
	print(str_build)		
