extends Node3D


@export var root_world_position: Vector3 = Vector3.ZERO
@export var root_world_horizontal_rotation_ccw_360: float = 0.0
@export var root_local_elevation_degrees: float = 0.0
@export var root_local_muzzle_height: float = 1.0
@export var cannon_tube_diameter_meters: float = 0.155 # M109 cannon tube diameter
@export var size_multiplicator: float = 0.001

@export var node_root_to_move: Node3D
@export var node_anchor_cannon_launcher_to_rotate: Node3D
@export var node_muzzle_to_move_3d: Node3D
@export var node_cannon_scaled_tube_middle_3d: Node3D



func _process(delta: float) -> void:
	if not is_inside_tree():
		return
	set_cannon_transform(
		root_world_position,
		root_world_horizontal_rotation_ccw_360,
		root_local_elevation_degrees,
		root_local_muzzle_height
	)

func set_cannon_position(world_position: Vector3) -> void:
	root_world_position = world_position
	refresh_view()

func set_cannon_horizontal_rotation(world_horizontal_rotation_ccw_360: float) -> void:
	root_world_horizontal_rotation_ccw_360 = world_horizontal_rotation_ccw_360
	refresh_view()

func set_cannon_elevation_rotation(local_elevation_degrees: float) -> void:
	root_local_elevation_degrees = local_elevation_degrees
	refresh_view()

func set_cannon_rotation(
		world_horizontal_rotation_ccw_360: float,
		local_elevation_degrees: float
	) -> void:
	# Set root rotation
	root_world_horizontal_rotation_ccw_360 = world_horizontal_rotation_ccw_360
	root_local_elevation_degrees = local_elevation_degrees
	refresh_view()

func set_cannon_transform(
		world_position: Vector3,
		world_horizontal_rotation_ccw_360: float,
		local_elevation_degrees: float,
		local_muzzle_height: float
	) -> void:
	# Set root position
	root_world_position = world_position
	root_world_horizontal_rotation_ccw_360 = world_horizontal_rotation_ccw_360
	root_local_elevation_degrees = local_elevation_degrees
	root_local_muzzle_height = local_muzzle_height
	refresh_view()

func refresh_view() -> void:
	var mid_cannon_position = Vector3(0.0, 0.0, - root_local_muzzle_height / 2.0)
	# rotate the vector on the horizontal plane
	mid_cannon_position = mid_cannon_position.rotated(Vector3.RIGHT, deg_to_rad(root_local_elevation_degrees))
	mid_cannon_position = mid_cannon_position.rotated(Vector3.UP, deg_to_rad(root_world_horizontal_rotation_ccw_360))

	var muzzle_world_position = root_world_position + mid_cannon_position*2.0 * size_multiplicator
	var cannon_world_position = root_world_position + mid_cannon_position * size_multiplicator

	if node_anchor_cannon_launcher_to_rotate:
		node_anchor_cannon_launcher_to_rotate.global_position = cannon_world_position
		node_anchor_cannon_launcher_to_rotate.rotation_degrees = Vector3(root_local_elevation_degrees, root_world_horizontal_rotation_ccw_360, 0.0)

	if node_muzzle_to_move_3d:
		node_muzzle_to_move_3d.global_position = muzzle_world_position
		node_muzzle_to_move_3d.rotation_degrees = Vector3(root_local_elevation_degrees, root_world_horizontal_rotation_ccw_360, 0.0)

	if node_cannon_scaled_tube_middle_3d:
		node_cannon_scaled_tube_middle_3d.global_position = mid_cannon_position * size_multiplicator + root_world_position*size_multiplicator
		node_cannon_scaled_tube_middle_3d.rotation_degrees = Vector3(root_local_elevation_degrees, root_world_horizontal_rotation_ccw_360, 0.0)
		node_cannon_scaled_tube_middle_3d.scale = Vector3(cannon_tube_diameter_meters, cannon_tube_diameter_meters, root_local_muzzle_height )
	
	if node_root_to_move:
		node_root_to_move.global_position = root_world_position*size_multiplicator
		node_root_to_move.scale = Vector3(size_multiplicator, size_multiplicator, size_multiplicator)
