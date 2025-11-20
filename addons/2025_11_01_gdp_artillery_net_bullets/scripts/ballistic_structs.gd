class_name BallisticStructs extends Resource



static func copy_start_point(from: STRUCT_BallisticStartPoint, to: STRUCT_BallisticStartPoint):
	if to != null and from !=null:
		to.player_claim_id = from.player_claim_id
		to.player_lobby_index_id = from.player_lobby_index_id
		to.pool_index_id = from.pool_index_id
		to.bullet_in_pool_index_id = from.bullet_in_pool_index_id
		to.start_muzzle_position = from.start_muzzle_position
		to.start_ntp_utc_timestamp_date_ms = from.start_ntp_utc_timestamp_date_ms
		to.gun_elevation_degree = from.gun_elevation_degree
		to.world_horizontal_rotation_deg_forward_ccw_360 = from.world_horizontal_rotation_deg_forward_ccw_360
		to.start_muzzle_velocity_meter_per_seconds = from.start_muzzle_velocity_meter_per_seconds
	else:
		to = STRUCT_BallisticStartPoint.new()
		

static func copy_end_point(from: STRUCT_BallisticsEndPoint, to: STRUCT_BallisticsEndPoint):
	if to!=null and from !=null:
		to.pool_index_id = from.pool_index_id
		to.bullet_in_pool_index_id = from.bullet_in_pool_index_id
		to.end_world_position = from.end_world_position
		to.end_ntp_utc_timestamp_date_ms = from.end_ntp_utc_timestamp_date_ms
	else:
		to = STRUCT_BallisticsEndPoint.new()
		


const GRAVITY_CM_PER_SQUARE_SECOND = 981.0  # cm/s² (downward)

# common M109 charges
const MUZZLE_VELOCITIES_CM_PER_SQUARE_SECOND = {	
	3: 28000.0,
	4: 35000.0,
	5: 43000.0,
	6: 53000.0,
	7: 65000.0,
	8: 82700.0  
}

class STRUCT_BulletCurrentPoint extends Resource:
	var start_point_cm: STRUCT_BallisticStartPoint
	var bullet_current_point_cm_i32cm: Vector3i

class STRUCT_BallisticStartPoint extends Resource:
	# Diffused event at spawn bullet
	var player_claim_id: int = -1 # Unique player id who fired the bullet
	var player_lobby_index_id: int = -1 # Unique player lobby index id who fired the bullet
	var pool_index_id: int = -1 # Game can have several type of ballistic bullets pools
	var bullet_in_pool_index_id: int = -1 # Each pool can have several bullets
	var start_ntp_utc_timestamp_date_ms: int = 0 # You need precision time sync and logs to use the bullets
	var start_muzzle_position_i32cm: Vector3i = Vector3.ZERO # World position of the muzzle at start
	var gun_elevation_degree_i32deg: int = 0 # vertical elevation of the gun at firing time
	var world_horizontal_rotation_deg_forward_ccw_360_i32deg: int = 0 # horizontal rotation of the gun in the game world value not relative to the carrier
	var start_muzzle_velocity_cm_per_seconds_i32cm: int = 0 # initial speed of the bullet at the muzzle
		

class STRUCT_BallisticsEndPoint extends Resource:
	# Diffused event at unspawn bullet for any reason (collision, max range, server cleanup, etc)
	var pool_index_id: int = -1
	var bullet_in_pool_index_id: int = -1
	var end_world_position_i32cm: Vector3i = Vector3i.ZERO
	var end_ntp_utc_timestamp_date_ms: int = 0

   
class STRUCT_WorldPositionToGPS extends Resource:
	# This class give information on Godot World compare to GPS coordinates
	var world_position_i32cm: Vector3i = Vector3.ZERO
	var latitude_i360deg: float = 0.0
	var longitude_i360deg: float = 0.0
	var altitude_i32cm: float = 0.0

class STRUCT_BallisticStartEventGPS extends Resource:
	# Give additional GPS information at the start of the bullet
	var pool_index_id: int = -1
	var bullet_in_pool_index_id: int = -1
	var world_position_i32cm: Vector3i = Vector3.ZERO
	var latitude_i360deg: float = 0.0
	var longitude_i360deg: float = 0.0
	var altitude_i32cm: float = 0.0

class STRUCT_BallisticEndEventGPS extends Resource:
	# Give additional GPS information at the end of the bullet
	# Diffused event at collision or max range on game server side
	var pool_index_id: int = -1
	var bullet_in_pool_index_id: int = -1
	var world_position_i32cm: Vector3i = Vector3i.ZERO
	var latitude_i360deg: int = 0.0
	var longitude_i360deg: int = 0.0
	var altitude_i32cm: int = 0.0



class STRUCT_IntCmPrecision:
	# I need an artillery dos game playble on a planet earth scale
	# So I need to store position in cm precision with int32
	# Max integer value for cm precision is 21,474,836.47 meter (21,474 km)
	var value_i32cm: int = 0

	
	const MAX_VALUE_I32CM = 2147483647  # Max positive value for int32
	const MIN_VALUE_I32CM = -2147483648 # Min negative value for int32
	const MAX_VALUE_IN_KM = 21474.83647  # Convert cm to km
	const MIN_VALUE_IN_KM = -21474.83648  # Convert cm to km
	const MAX_VALUE_IN_METER = 21474836.47  # Convert cm to meter
	const MIN_VALUE_IN_METER = -21474836.48  # Convert cm to meter

class STRUCT_IntMaxDegreePrecision360:
	## I want to make artillery game on a planet scale so 42000 km circumference max.
	## it means that I need precise degree instead of the classic 180.00
	## Max integer value for degree with 0.000001 precision and 360 degrees is 360,000,000 
	var value_i32_360_000000: int = 0
