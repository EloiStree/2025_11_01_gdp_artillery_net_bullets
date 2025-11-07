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
		


const GRAVITY = 9.81  # m/s² (downward)

# common M109 charges
const MUZZLE_VELOCITIES_METER_PER_SQUARE_SECOND = {	
	3: 280.0,
	4: 350.0,
	5: 430.0,
	6: 530.0,
	7: 650.0,
	8: 827.0  
}

class STRUCT_BulletCurrentPoint extends Resource:
	var start_point: STRUCT_BallisticStartPoint
	var bullet_current_point: Vector3

class STRUCT_BallisticStartPoint extends Resource:
	# Diffused event at spawn bullet
	var player_claim_id: int = -1 # Unique player id who fired the bullet
	var player_lobby_index_id: int = -1 # Unique player lobby index id who fired the bullet
	var pool_index_id: int = -1 # Game can have several type of ballistic bullets pools
	var bullet_in_pool_index_id: int = -1 # Each pool can have several bullets
	var start_muzzle_position: Vector3 = Vector3.ZERO # World position of the muzzle at start
	var start_ntp_utc_timestamp_date_ms: int = 0 # You need precision time sync and logs to use the bullets
	var gun_elevation_degree: float = 0.0 # vertical elevation of the gun at firing time  
	var world_horizontal_rotation_deg_forward_ccw_360: float = 0.0 # horizontal rotation of the gun in the game world value not relative to the carrier
	var start_muzzle_velocity_meter_per_seconds: float = 0.0 # initial speed of the bullet at the muzzle


	func to_string() -> String:
		return "BallisticStartPoint(player_claim_id=%d, player_lobby_index_id=%d, pool_index_id=%d, bullet_in_pool_index_id=%d, start_muzzle_position=%s, start_ntp_utc_timestamp_date_ms=%d, gun_elevation_degree=%.2f, world_horizontal_rotation_deg_forward_ccw_360=%.2f, start_muzzle_velocity_meter_per_seconds=%.2f)" % [
			player_claim_id,
			player_lobby_index_id,
			pool_index_id,
			bullet_in_pool_index_id,
			start_muzzle_position,
			start_ntp_utc_timestamp_date_ms,
			gun_elevation_degree,
			world_horizontal_rotation_deg_forward_ccw_360,
			start_muzzle_velocity_meter_per_seconds
		]
		

class STRUCT_BallisticsEndPoint extends Resource:
	# Diffused event at unspawn bullet for any reason (collision, max range, server cleanup, etc)
	var pool_index_id: int = -1
	var bullet_in_pool_index_id: int = -1
	var end_world_position: Vector3 = Vector3.ZERO
	var end_ntp_utc_timestamp_date_ms: int = 0

	func to_string() -> String:
		return "BallisticsEndPoint(pool_index_id=%d, bullet_in_pool_index_id=%d, end_world_position=%s, end_ntp_utc_timestamp_date_ms=%d)" % [
			pool_index_id,
			bullet_in_pool_index_id,
			end_world_position,
			end_ntp_utc_timestamp_date_ms
		]

   
class STRUCT_WorldPositionToGPS extends Resource:
	# This class give information on Godot World compare to GPS coordinates
	var world_position: Vector3 = Vector3.ZERO
	var latitude_deg: float = 0.0
	var longitude_deg: float = 0.0
	var altitude_meters: float = 0.0

class STRUCT_BallisticStartEventGPS extends Resource:
	# Give additional GPS information at the start of the bullet
	var pool_index_id: int = -1
	var bullet_in_pool_index_id: int = -1
	var world_position: Vector3 = Vector3.ZERO
	var latitude_deg: float = 0.0
	var longitude_deg: float = 0.0
	var altitude_meters: float = 0.0

class STRUCT_BallisticEndEventGPS extends Resource:
	# Give additional GPS information at the end of the bullet
	# Diffused event at collision or max range on game server side
	var pool_index_id: int = -1
	var bullet_in_pool_index_id: int = -1
	var world_position: Vector3 = Vector3.ZERO
	var latitude_deg: float = 0.0
	var longitude_deg: float = 0.0
	var altitude_meters: float = 0.0
