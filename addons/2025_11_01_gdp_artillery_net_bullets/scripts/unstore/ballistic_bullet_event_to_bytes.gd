class_name BallisticBulletEventToBytes extends Node




# static func parse_start_and_end_bullets_to_bytes(
#     fired_start_point: BallisticStructs.STRUCT_BallisticStartPoint,
#     destroyed_end_point: BallisticStructs.STRUCT_BallisticsEndPoint
# ) -> PoolByteArray:
#     var byte_array = PoolByteArray()
#     byte_array.append_int(fired_start_point.player_claim_id)
#     byte_array.append_int(fired_start_point.player_lobby_index_id)
#     byte_array.append_int(fired_start_point.pool_index_id)
#     byte_array.append_int(fired_start_point.bullet_in_pool_index_id)
#     byte_array.append_vector3(fired_start_point.start_muzzle_position)
#     byte_array.append_int(fired_start_point.start_ntp_utc_timestamp_date_ms)
#     byte_array.append_float(fired_start_point.gun_elevation_degree)
#     byte_array.append_float(fired_start_point.world_horizontal_rotation_deg_forward_ccw_360)
#     byte_array.append_float(fired_start_point.start_muzzle_velocity_meter_per_seconds)

#     byte_array.append_int(destroyed_end_point.pool_index_id)
#     byte_array.append_int(destroyed_end_point.bullet_in_pool_index_id)
#     byte_array.append_vector3(destroyed_end_point.end_world_position)
#     byte_array.append_int(destroyed_end_point.end_ntp_utc_timestamp_date_ms)

#     return byte_array


# static func parse_start_bullets_to_bytes(
#     fired_start_point: BallisticStructs.STRUCT_BallisticStartPoint,
# ) -> PoolByteArray:

#     var byte_array = PoolByteArray()
#     byte_array.append_int(fired_start_point.player_claim_id)
#     byte_array.append_int(fired_start_point.player_lobby_index_id)
#     byte_array.append_int(fired_start_point.pool_index_id)
#     byte_array.append_int(fired_start_point.bullet_in_pool_index_id)
#     byte_array.append_vector3(fired_start_point.start_muzzle_position)
#     byte_array.append_int(fired_start_point.start_ntp_utc_timestamp_date_ms)
#     byte_array.append_float(fired_start_point.gun_elevation_degree)
#     byte_array.append_float(fired_start_point.world_horizontal_rotation_deg_forward_ccw_360)
#     byte_array.append_float(fired_start_point.start_muzzle_velocity_meter_per_seconds)

#     return byte_array
