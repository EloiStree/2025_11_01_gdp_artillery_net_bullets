
class_name NodeBasicTurret extends Node3D

signal on_fire_bullet_requested( turret_position:Vector3,
								turret_horizontal_rotation_in_degree:float,
								turret_elevation_rotation_in_degree:float,
								bullet_initial_velocity_meter_per_second:float
								)
signal on_turret_position_changed( new_turret_position:Vector3)
signal on_turret_rotation_changed( new_horizontal_rotation_in_degree_ccw_360:float, new_elevation_rotation_in_degree:float)  


@export var player_node:Node3D
@export var turret_horizontal_rotation:float = 0.0
@export var turret_elevation_rotation:float = 0.0
@export var bullet_initial_velocity_meter_per_second:float = 100.0
@export var turret_position_in_meter:Vector3 = Vector3.ZERO


@export var turret_horizontal_rotation_in_degree:float =180.0
@export var turret_elevation_rotation_in_degree:float =45.0
@export var clamping_min_elevation:float = -20.0
@export var clamping_max_elevation:float = 89.999


@export var rotation_horizon_speed_degree_per_second:float = 30.0
@export var rotation_elevation_speed_degree_per_second:float = 20.0
@export var random_respawn_position:float = 50.0


@export var bool_is_rotating_left:bool = false
@export var bool_is_rotating_right:bool = false
@export var bool_is_rotating_up:bool = false
@export var bool_is_rotating_down:bool = false


func _ready() -> void:
	turret_position_in_meter = global_position
	emit_signal("on_turret_position_changed", turret_position_in_meter)
	emit_signal("on_turret_rotation_changed", turret_horizontal_rotation_in_degree, turret_elevation_rotation_in_degree)

func _process(delta: float) -> void:
	if bool_is_rotating_left:
		turret_horizontal_rotation_in_degree += rotation_horizon_speed_degree_per_second * delta
	if bool_is_rotating_right:
		turret_horizontal_rotation_in_degree -= rotation_horizon_speed_degree_per_second * delta
	if bool_is_rotating_up:
		turret_elevation_rotation_in_degree += rotation_elevation_speed_degree_per_second * delta
	if bool_is_rotating_down:
		turret_elevation_rotation_in_degree -= rotation_elevation_speed_degree_per_second * delta

	turret_elevation_rotation_in_degree = clamp(turret_elevation_rotation_in_degree, clamping_min_elevation, clamping_max_elevation)
	if bool_is_rotating_left or bool_is_rotating_right or bool_is_rotating_up or bool_is_rotating_down:
		emit_signal("on_turret_rotation_changed", turret_horizontal_rotation_in_degree, turret_elevation_rotation_in_degree)


func request_turret_new_random_position() -> void:
	var random_offset = Vector3(
		randf_range(-random_respawn_position, random_respawn_position),
		0.0,
		randf_range(-random_respawn_position, random_respawn_position)
	)
	turret_position_in_meter = player_node.global_position + random_offset
	global_position = turret_position_in_meter
	emit_signal("on_turret_position_changed", turret_position_in_meter)
		

func request_turret_to_fire_bullet() -> void:
	emit_signal("on_fire_bullet_requested",
		turret_position_in_meter,
		turret_horizontal_rotation_in_degree,
		turret_elevation_rotation_in_degree,
		bullet_initial_velocity_meter_per_second
	)
