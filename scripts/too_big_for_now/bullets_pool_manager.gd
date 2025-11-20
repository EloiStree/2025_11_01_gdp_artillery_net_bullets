# class_name BulletsPoolManager extends Node


# @export var current_ntp_utc_timestamp_date_ms: int = 0
# @export var bullets_to_current_point: Array[ BallisticStructs.STRUCT_BulletCurrentPoint] = []
# @export var use_air_resistance: bool = false


# # signal on_bullet_reach_zero_height(bullet_start_point: STRUCT_BallisticStartPoint, bullet_end_point: STRUCT_BallisticsEndPoint) -> void:

# func _ready() -> void:
#     pass  # Replace with function body.


# func fire_bullet_from_node(  current_ntp_utc_timestamp_date_ms: int, node_from: Node3D,
#                             bullet_speed_velocity: float=100,
#                             ) -> void:
#     var position = node_from.global_position
#     var rotation = node_from.global_rotation_degrees
#     var horiwzontal_rotation_degree_ccw = rotation.y
#     var elevation_degree = rotation.x
#     fire_bullet( current_ntp_utc_timestamp_date_ms,
#                 position,
#                 horiwzontal_rotation_degree_ccw,
#                 elevation_degree,
#                 bullet_speed_velocity
#                 )

# func fire_bullet(   current_ntp_utc_timestamp_date_ms: int,
#                     start_point:Vector3
#                     horiwzontal_rotation_degree: float,
#                     elevation_degree: float,
#                     bullet_speed_velocity: float,
#                     ) -> void:
#     var bullet = BallisticStructs.STRUCT_BulletCurrentPoint.new()
#     var start_point_struct = BallisticStructs.STRUCT_BallisticStartPoint.new()
#     start_point_struct.start_muzzle_position = start_point
#     start_point_struct.start_ntp_utc_timestamp_date_ms = current_ntp_utc_timestamp
#     start_point_struct.world_horizontal_rotation_deg_forward_ccw_360 = horiwzontal_rotation_degree
#     start_point_struct.gun_elevation_degrees = elevation_degree
#     start_point_struct.start_muzzle_velocity_meter_per_seconds = bullet_speed_velocity
#     start_point_struct.player_claim_id = player_clain_id
#     start_point_struct.player_lobby_index_id = player_lobby_index_id

#     start_point_struct.player_claim_id=0
#     start_point_struct.player_lobby_index_id=0
#     start_point_struct.pool_index_id=0
#     start_point_struct.bullet_in_pool_index_id=bullets_to_current_point.size()
 
#     bullet.start_point = start_point_struct
#     bullet.bullet_current_point = start_point_struct.start_muzzle_position
#     bullets_to_current_point.append(bullet)

# func add_bullet_start_point(start_point: STRUCT_BallisticStartPoint) -> void:
#     var bullet = BallisticStructs.STRUCT_BulletCurrentPoint.new()
#     bullet.start_point = start_point
#     bullet.bullet_current_point = start_point.start_muzzle_position
#     bullets_to_current_point.append(bullet)

