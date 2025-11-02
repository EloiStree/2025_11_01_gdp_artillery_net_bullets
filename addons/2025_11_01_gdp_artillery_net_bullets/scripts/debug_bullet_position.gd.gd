@tool
extends Node3D

# Export variables for easy tweaking in the editor
@export var simulation_time: float = 0.0: set = _set_simulation_time
@export_range(0,1000,0.1) var initial_velocity_meter_per_second: int = 200: set = _set_charge
#@export_range(3, 8, 1) var charge: int = 8: set = _set_charge
@export_range(0.0, 90.0, 0.1) var elevation_degree: float = 45.0: set = _set_elevation_deg
@export_range(-360, 360, 0.1) var horizontal_rotation_degree: float = 45.0: set = _set_horizontal_rotation_deg

@export_range(0, 10.0, 0.01) var muzzle_height: float = 1.0: set = _set_muzzle_height
@export var bullet_debug_node: Node3D
@export var muzzle_debug_node: Node3D


@export var multiplicator: float = 0.001
@export var debug_time: float = 20
@export var use_air_resistance: bool = false

# Store the initial muzzle position to avoid circular updates
var _muzzle_base_position: Vector3
var _elapsed_time: float = 0.0
var _time_to_test: float = 10.0  # seconds


func _ready() -> void:
	# Store the initial position as the muzzle base
	_muzzle_base_position = global_position
	update_position()

func _process(delta: float) -> void:
	_elapsed_time += delta
	_time_to_test = fmod(_elapsed_time,debug_time)
	update_position()

func update_position() -> void:
	# Use the utility function to compute shell position
	#var mps = BallisticStructs.MUZZLE_VELOCITIES_METER_PER_SQUARE_SECOND.get(charge, 0.0)
	var mps = initial_velocity_meter_per_second
	
	var shell_pos: Vector3 = BallisticBulletUtility.ballistic_bullet(
		_time_to_test,
		mps,
		elevation_degree,
		horizontal_rotation_degree,
		_muzzle_base_position
	)
	if use_air_resistance:
		shell_pos = BallisticBulletUtility.ballistic_bullet_with_air_resistance(
			_time_to_test,
			mps,
			elevation_degree,
			horizontal_rotation_degree,
			_muzzle_base_position
		)

	# Update debug node position if available
	if bullet_debug_node:
		bullet_debug_node.global_position = shell_pos * multiplicator
	
	if muzzle_debug_node:
		# Position muzzle debug node with height and rotation
		var muzzle_offset = -Vector3.FORWARD * muzzle_height
		muzzle_offset = muzzle_offset.rotated(Vector3.RIGHT, deg_to_rad(elevation_degree))
		muzzle_offset = muzzle_offset.rotated(Vector3.UP, deg_to_rad(horizontal_rotation_degree))
		muzzle_debug_node.global_position = (_muzzle_base_position + muzzle_offset) * multiplicator

# Setters for exported variables
func _set_simulation_time(value: float) -> void:
	simulation_time = value
	if _ready:
		update_position()

func _set_charge(value: int) -> void:
	initial_velocity_meter_per_second = value
	if _ready:
		update_position()
		
func _set_elevation_deg(value: float) -> void:
	elevation_degree = value
	if _ready:
		update_position()

func _set_muzzle_height(value: float) -> void:
	muzzle_height = value
	if _ready:
		update_position()

func _set_horizontal_rotation_deg(value: float) -> void:
	horizontal_rotation_degree = value
	if _ready:
		update_position()
