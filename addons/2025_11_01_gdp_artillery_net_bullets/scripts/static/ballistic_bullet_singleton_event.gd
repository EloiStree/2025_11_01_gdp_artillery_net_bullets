"""
Singleton to notify when a bullet is fired and when one is destroyed.
Can be used for gameplay logic or to broadcast to the multiplayer layer.
"""
class_name BallisticBulletSingletonEvent
extends Node


# Singleton instance reference
static var instance: BallisticBulletSingletonEvent

# Signals
signal on_bullet_fired(fired_start_point: BallisticStructs.STRUCT_BallisticStartPoint)
signal on_bullet_destroyed(
	fired_start_point: BallisticStructs.STRUCT_BallisticStartPoint,
	destroyed_end_point: BallisticStructs.STRUCT_BallisticsEndPoint
)

# === Listener Management ===
static func add_listener_start_bullet(listener: Callable) -> void:
	if instance:
		instance.on_bullet_fired.connect(listener)

static func remove_listener_start_bullet(listener: Callable) -> void:
	if instance:
		instance.on_bullet_fired.disconnect(listener)

static func add_listener_end_bullet(listener: Callable) -> void:
	if instance:
		instance.on_bullet_destroyed.connect(listener)

static func remove_listener_end_bullet(listener: Callable) -> void:
	if instance:
		instance.on_bullet_destroyed.disconnect(listener)

# === Internal Trigger Methods ===
func trigger_bullet_fired(fired_start_point: BallisticStructs.STRUCT_BallisticStartPoint) -> void:
	on_bullet_fired.emit(fired_start_point)

func trigger_bullet_destroyed(
	fired_start_point: BallisticStructs.STRUCT_BallisticStartPoint,
	destroyed_end_point: BallisticStructs.STRUCT_BallisticsEndPoint
) -> void:
	on_bullet_destroyed.emit(fired_start_point, destroyed_end_point)

# === Static Global Triggers (safe access) ===
static func from_global_trigger_bullet_fired(fired_start_point: BallisticStructs.STRUCT_BallisticStartPoint) -> void:
	if instance:
		instance.trigger_bullet_fired(fired_start_point)

static func from_global_trigger_bullet_destroyed(
	fired_start_point: BallisticStructs.STRUCT_BallisticStartPoint,
	destroyed_end_point: BallisticStructs.STRUCT_BallisticsEndPoint
) -> void:
	if instance:
		instance.trigger_bullet_destroyed(fired_start_point, destroyed_end_point)

# === Godot Lifecycle ===
func _enter_tree() -> void:
	if instance != null:
		queue_free()  # Prevent duplicate singletons
		return
	instance = self

func _exit_tree() -> void:
	if instance == self:
		instance = null
		
		
func print_bullet_fired(start_point: BallisticStructs.STRUCT_BallisticStartPoint) -> void:
	var str_build = "Bullet Fired: " + str(start_point)
	print(str_build)		

func print_bullet_destroyed(
	start_point: BallisticStructs.STRUCT_BallisticStartPoint,
	end_point: BallisticStructs.STRUCT_BallisticsEndPoint
) -> void:
	var str_build = "Bullet Destroyed - Start: " + str(start_point) + ", End: " + str(end_point)
	print(str_build)	
