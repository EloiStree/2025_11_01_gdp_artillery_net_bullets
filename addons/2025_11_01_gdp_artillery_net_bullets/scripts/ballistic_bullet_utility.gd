class_name BallisticBulletUtility extends Resource

# ballistic_bullet.gd
# Simulates M109 Paladin 155mm shell trajectory (no drag, no wind)
const GRAVITY = 9.81  # m/s² (downward)

# Muzzle velocities for common M109 charges (approximate, in m/s)
# Charge 3 to Charge 8 (simplified values)
const MUZZLE_VELOCITIES = {	
	3: 280.0,
	4: 350.0,
	5: 430.0,
	6: 530.0,
	7: 650.0,
	8: 827.0  # Max charge (M203 propelling charge)
}

static func ballistic_bullet(
	time: float,
	initial_velocity_mps: float,
	elevation_angle_deg: float,
	initial_position: Vector3 = Vector3.ZERO
) -> Vector3:
	"""
	Returns the 3D position of a projectile at time 't' using ballistic motion.
	
	Args:
		time (float): Time since firing (seconds)
		initial_velocity_mps (float): Muzzle velocity in meters per second
		elevation_angle_deg (float): Gun elevation angle in degrees (0 = horizontal)
		initial_position (Vector3): Starting position (usually muzzle)
	
	Returns:
		Vector3: World position at time 't'
	"""
	
	# Convert angle to radians
	var theta = deg_to_rad(elevation_angle_deg)
	
	# Initial velocity components
	var v0x = initial_velocity_mps * cos(theta)  # Horizontal
	var v0y = initial_velocity_mps * sin(theta)  # Vertical
	
	# Position equations (no air resistance):
	# x = v0x * t
	# y = v0y * t - 0.5 * g * t²
	# z = 0 (assuming firing in X-Y plane, Z = forward)
	
	var x = v0x * time
	var y = v0y * time - 0.5 * GRAVITY * time * time
	
	# Return in Godot's coordinate system: X right, Y up, Z forward
	return initial_position + Vector3(x, y, 0.0)


# === Example usage function for M109 Paladin ===
static func m109_paladin_bullet(
	time: float,
	charge: int = 8,
	elevation_deg: float = 45.0,
	muzzle_height: float = 2.5,  # Approx height of muzzle above ground
	muzzle_position: Vector3 = Vector3.ZERO
) -> Vector3:
	"""
	Convenience function for M109 Paladin simulation.
	
	Args:
		time: Time since firing
		charge: Propelling charge (3 to 8)
		elevation_deg: Gun elevation
		muzzle_height: Height of muzzle
		muzzle_position: Optional offset
	
	Returns: Position of shell
	"""
	
	if charge < 3 or charge > 8:
		push_error("M109 Charge must be 3 to 8")
		return Vector3.ZERO
	
	var v0 = MUZZLE_VELOCITIES[charge]
	var start_pos = muzzle_position + Vector3(0, muzzle_height, 0)
	
	return ballistic_bullet(time, v0, elevation_deg, start_pos)
