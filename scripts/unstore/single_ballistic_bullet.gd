

class_name SingleBallisticBullet extends Node
# This class allows to manage a pool of one single bullet.
# When trigger id destroy the bullet reserved to trigger a new one.




signal on_bullet_fired(fired_start_point : BallisticStructs.STRUCT_BallisticStartPoint)
signal on_bullet_destroyed(fired_start_point : BallisticStructs.STRUCT_BallisticStartPoint, destroyed_end_point : BallisticStructs.STRUCT_BallisticsEndPoint)
signal on_bullet_new_current_point(bullet_current_point : BallisticStructs.STRUCT_BulletCurrentPoint)
signal on_request_to_show_bullet()
signal on_request_to_hide_bullet()

@export var bullet_to_move_as_node: Node3D
@export var bullet_diameter_meters: float = 0.155 # M109 cannon tube diameter
@export var simulation_time: float = 0.0: set = _set_simulation_time
@export var max_time_seconds: float = 60.0

@export var bullet_current_point: BallisticStructs.STRUCT_BulletCurrentPoint
@export var end_point: BallisticStructs.STRUCT_BallisticsEndPoint

@export var multiplicator: float = 0.001
@export var use_air_resistance: bool = false
var _elapsed_time: float = 0.0

@export var _had_been_fired_yet_not_destroyed: bool = false


func update_bullet_size() -> void:
	if bullet_to_move_as_node:
		bullet_to_move_as_node.scale = Vector3.ONE * (bullet_diameter_meters)

func _ready() -> void:
	bullet_current_point = BallisticStructs.STRUCT_BulletCurrentPoint.new()
	bullet_current_point.start_point = BallisticStructs.STRUCT_BallisticStartPoint.new()
	end_point = BallisticStructs.STRUCT_BallisticsEndPoint.new()
	bullet_current_point.bullet_current_point = Vector3.ZERO
	update_bullet_size()
	update_position()


func fire_bullet_basic_anonymous(
		start_muzzle_position: Vector3,
		world_horizontal_rotation_deg_forward_ccw_360: float,
		gun_elevation_degree: float,
		start_muzzle_velocity_meter_per_seconds: float
	) -> void:

	var start_point = BallisticStructs.STRUCT_BallisticStartPoint.new()
	start_point.player_claim_id = 0
	start_point.player_lobby_index_id = 0
	start_point.pool_index_id = 0
	start_point.bullet_in_pool_index_id = 0
	start_point.start_ntp_utc_timestamp_date_ms = 0
	start_point.start_muzzle_position = start_muzzle_position
	start_point.gun_elevation_degree = gun_elevation_degree
	start_point.world_horizontal_rotation_deg_forward_ccw_360 = world_horizontal_rotation_deg_forward_ccw_360
	start_point.start_muzzle_velocity_meter_per_seconds = start_muzzle_velocity_meter_per_seconds
	#print("Firing bullet with start point:", start_point)
	fire_bullet(start_point)
	
func fire_bullet(start_point: BallisticStructs.STRUCT_BallisticStartPoint) -> void:

	if _had_been_fired_yet_not_destroyed:
		destroy_bullet()

	_had_been_fired_yet_not_destroyed = true
	bullet_current_point.start_point = start_point
	bullet_current_point.bullet_current_point = start_point.start_muzzle_position

	_elapsed_time = 0.0

	emit_signal("on_bullet_fired", start_point)
	emit_signal("on_request_to_show_bullet")
	update_bullet_size()
	update_position()
	

func _process(delta: float) -> void:
	if not _had_been_fired_yet_not_destroyed:
		return
	_elapsed_time += delta
	update_position()

func update_position() -> void:
	if not _had_been_fired_yet_not_destroyed:
		return

	# Use the utility function to compute shell position
	var mps = bullet_current_point.start_point.start_muzzle_velocity_meter_per_seconds
	
	var shell_pos := Vector3.ZERO
	if use_air_resistance:
		shell_pos = BallisticBulletUtility.ballistic_bullet_with_air_resistance(
			_elapsed_time,
			mps,
			bullet_current_point.start_point.gun_elevation_degree,
			bullet_current_point.start_point.world_horizontal_rotation_deg_forward_ccw_360,
			bullet_current_point.start_point.start_muzzle_position
		)
	else:
		shell_pos = BallisticBulletUtility.ballistic_bullet(
			_elapsed_time,
			mps,
			bullet_current_point.start_point.gun_elevation_degree,
			bullet_current_point.start_point.world_horizontal_rotation_deg_forward_ccw_360,
			bullet_current_point.start_point.start_muzzle_position
		)

	# Update debug node position if available
	if bullet_to_move_as_node:
		
		bullet_to_move_as_node.global_position = shell_pos * multiplicator

	# Update current point
	bullet_current_point.bullet_current_point = shell_pos
	emit_signal("on_bullet_new_current_point", bullet_current_point)

	if _elapsed_time >= max_time_seconds:
		destroy_bullet()
	
	if shell_pos.y < -1.0:
		destroy_bullet()

func destroy_bullet() -> void:
	if not _had_been_fired_yet_not_destroyed:
		push_error("Bullet is not fired yet or already destroyed.")
		return

	var bullet_time_in_air_seconds = _elapsed_time
	_had_been_fired_yet_not_destroyed = false

	# Fill end point data
	end_point.pool_index_id = bullet_current_point.start_point.pool_index_id
	end_point.bullet_in_pool_index_id = bullet_current_point.start_point.bullet_in_pool_index_id
	end_point.end_ntp_utc_timestamp_date_ms = bullet_current_point.start_point.start_ntp_utc_timestamp_date_ms + int(bullet_time_in_air_seconds * 1000)
	end_point.end_world_position = bullet_current_point.bullet_current_point

	emit_signal("on_bullet_destroyed", bullet_current_point.start_point, end_point)
	emit_signal("on_request_to_hide_bullet")
	#print("Bullet destroyed with end point:", end_point)

func reset_to_wait_next_fire() -> void:
	_elapsed_time = 0.0
	# bullet_current_point = BallisticStructs.STRUCT_BulletCurrentPoint.new()
	# bullet_current_point.start_point = BallisticStructs.STRUCT_BallisticStartPoint.new()
	# bullet_current_point.bullet_current_point = Vector3.ZERO
	# end_point = BallisticStructs.STRUCT_BallisticsEndPoint.new()
	update_position()

func _set_simulation_time(value: float) -> void:
	simulation_time = value

### NOTE Maybe create a singleton outside of this class that can received from signal creation and destruction of bullets
