class_name BallisticBulletUtility extends Resource

static func ballistic_bullet(
	relative_time_in_air_seconds: float,
	initial_velocity_meter_per_second: float,
	elevation_angle_degree: float,
	world_horizontal_rotation_degrees_forward_ccw_360: float,
	initial_position: Vector3 = Vector3.ZERO,
	gravity_acceleration: float = 9.81,
) -> Vector3:
	"""
	Calculates the position of a ballistic bullet at a given time after firing.
	Without the effects of a real world: air resistance, wind, etc.
	"""
	
	# Convert angle to radians
	var theta = deg_to_rad(elevation_angle_degree)
	
	# Initial velocity components
	var v0x = initial_velocity_meter_per_second * cos(theta)  # Horizontal
	var v0y = initial_velocity_meter_per_second * sin(theta)  # Vertical
	
	# Position equations (no air resistance):
	# x = v0x * t
	# y = v0y * t - 0.5 * g * t²
	
	var t_squared = relative_time_in_air_seconds * relative_time_in_air_seconds
	var x = v0x * relative_time_in_air_seconds
	var y = v0y * relative_time_in_air_seconds - 0.5 * gravity_acceleration * t_squared
	
	var local_position = Vector3(x, y, 0.0)
	var rotated_position = local_position.rotated(Vector3.UP, deg_to_rad(world_horizontal_rotation_degrees_forward_ccw_360+90))
	
	return initial_position + rotated_position



"""
Yes — air resistance (drag) is very important.
The 155 mm shells it fires travel long distances (up to 30 km or more), so aerodynamic drag has a major effect on:
Range — it reduces velocity, cutting how far the shell flies.
Trajectory — it alters the shape of the shell’s path.
Time of flight — it increases how long the projectile is in the air.
Accuracy — it amplifies small errors in angle or charge.
That’s why artillery fire control systems always use ballistic tables or computer models that include drag coefficients for different shell types, air density, wind, and temperature.
"""




static func ballistic_bullet_with_air_resistance(
	relative_time_in_air_seconds: float,
	initial_velocity_meter_per_second: float,
	elevation_angle_degree: float,
	world_horizontal_rotation_degrees_forward_ccw_360: float,
	initial_position: Vector3 = Vector3.ZERO,
	gravity_acceleration: float = 9.81,
	drag_coefficient: float = 0.47,
	air_density: float = 1.225,
	projectile_cross_sectional_area: float = 0.019635,  # ~155mm shell
	projectile_mass: float = 43.0,  # kg, typical 155mm shell
	time_step: float = 0.01
) -> Vector3:
	"""
	Calculates the position of a ballistic bullet with air resistance simulation.
	Uses numerical integration to account for drag effects.
	"""
	
	# Convert angle to radians
	var theta = deg_to_rad(elevation_angle_degree)
	
	# Initial velocity components (local coordinates)
	var vx = initial_velocity_meter_per_second * cos(theta)
	var vy = initial_velocity_meter_per_second * sin(theta)
	
	# Position components
	var x = 0.0
	var y = 0.0
	
	# Drag constant: k = 0.5 * Cd * ρ * A / m
	var drag_constant = 0.5 * drag_coefficient * air_density * projectile_cross_sectional_area / projectile_mass
	
	var t = 0.0
	while t < relative_time_in_air_seconds:
		var dt = min(time_step, relative_time_in_air_seconds - t)
		
		# Current velocity magnitude
		var v_magnitude = sqrt(vx * vx + vy * vy)
		
		# Drag force components (opposite to velocity direction)
		var drag_force_magnitude = drag_constant * v_magnitude * v_magnitude
		var drag_x = -drag_force_magnitude * (vx / v_magnitude) if v_magnitude > 0 else 0.0
		var drag_y = -drag_force_magnitude * (vy / v_magnitude) if v_magnitude > 0 else 0.0
		
		# Acceleration components
		var ax = drag_x
		var ay = -gravity_acceleration + drag_y
		
		# Update velocity (Euler integration)
		vx += ax * dt
		vy += ay * dt
		
		# Update position
		x += vx * dt
		y += vy * dt
		
		t += dt
	
	var local_position = Vector3(x, y, 0.0)
	var rotated_position = local_position.rotated(Vector3.UP, deg_to_rad(world_horizontal_rotation_degrees_forward_ccw_360+90))
	
	return initial_position + rotated_position



func compute_ballistic_curve_points(
		initial_position: Vector3,
		world_horizontal_rotation_degrees_forward_ccw_360: float,
		elevation_angle_degree: float,
		initial_velocity_meter_per_second: float,
		time_step_seconds: float = 1.0,
		max_time_seconds: float = 30.0
	) -> Array:
	"""
	Computes a series of points representing the ballistic trajectory of a bullet.
	"""
	var points: Array = []
	var t: float = 0.0
	
	while t <= max_time_seconds:
		var point: Vector3 = ballistic_bullet(
			t,
			initial_velocity_meter_per_second,
			elevation_angle_degree,
			world_horizontal_rotation_degrees_forward_ccw_360,
			initial_position
		)
		points.append(point)
		t += time_step_seconds
	
	return points
