class_name BallisticStructs extends Resource


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

class STRUCT_BallisticStartPoint:
    # Diffused event at spawn bullet
    var player_claim_id: int = -1 # Unique player id who fired the bullet
    var player_lobby_index_id: int = -1 # Unique player lobby index id who fired the bullet
    var pool_index_id: int = -1 # Game can have several type of ballistic bullets pools
    var bullet_in_pool_index_id: int = -1 # Each pool can have several bullets
    var start_muzzle_position: Vector3 = Vector3.ZERO # World position of the muzzle at start
    var start_ntp_utc_timestamp_date_ms: int = 0 # You need precision time sync and logs to use the bullets
    var gun_elevation_degrees: float = 0.0 # vertical elevation of the gun at firing time  
    var world_horizontal_rotation_deg_forward_ccw_360: float = 0.0 # horizontal rotation of the gun in the game world value not relative to the carrier
    var start_muzzle_velocity_meter_per_seconds: float = 0.0 # initial speed of the bullet at the muzzle

class STRUCT_BallisticsEndPoint:
    # Diffused event at unspawn bullet for any reason (collision, max range, server cleanup, etc)
    var pool_index_id: int = -1
    var bullet_in_pool_index_id: int = -1
    var end_world_position: Vector3 = Vector3.ZERO
    var end_ntp_utc_timestamp_date_ms: int = 0

   
class STRUCT_WorldPositionToGPS:
    # This class give information on Godot World compare to GPS coordinates
    var world_position: Vector3 = Vector3.ZERO
    var latitude_deg: float = 0.0
    var longitude_deg: float = 0.0
    var altitude_meters: float = 0.0

class STRUCT_BallisticStartEventGPS:
    # Give additional GPS information at the start of the bullet
    var pool_index_id: int = -1
    var bullet_in_pool_index_id: int = -1
    var world_position: Vector3 = Vector3.ZERO
    var latitude_deg: float = 0.0
    var longitude_deg: float = 0.0
    var altitude_meters: float = 0.0

class STRUCT_BallisticEndEventGPS:
    # Give additional GPS information at the end of the bullet
    # Diffused event at collision or max range on game server side
    var pool_index_id: int = -1
    var bullet_in_pool_index_id: int = -1
    var world_position: Vector3 = Vector3.ZERO
    var latitude_deg: float = 0.0
    var longitude_deg: float = 0.0
    var altitude_meters: float = 0.0


