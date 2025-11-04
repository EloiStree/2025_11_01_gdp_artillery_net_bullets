class_name NodeBasicTurretCurveEvaluation extends Node

@export var turret_to_observe : NodeBasicTurret

signal on_ballistic_curve_evaluated(points: Array[Vector3])

func _ready() -> void:
    # listen to turret rotation changes
    turret_to_observe.connect("on_turret_rotation_changed", _on_turret_rotation_changed)
    turret_to_observe.connect("on_turret_new_position", _on_turret_new_position)

func update_ballistic_curve() -> void:
    var points: Array[Vector3] = []
    var simulation_time: float = 0.0
    var time_step: float = 0.1
    var max_time: float = 30.0
    while simulation_time <= max_time:
        var point: Vector3 = BallisticBulletUtility.ballistic_bullet_with_air_resistance(
            simulation_time,
            turret_to_observe.initial_velocity_meter_per_second,
            turret_to_observe.root_local_elevation_degrees,
            turret_to_observe.root_world_horizontal_rotation_ccw_360,
            turret_to_observe.get_muzzle_world_position()
        )
        points.append(point)
        simulation_time += time_step
    on_ballistic_curve_evaluated.emit(points)

# Add the missing callback functions
func _on_turret_rotation_changed():
    update_ballistic_curve()

func _on_turret_new_position():
    update_ballistic_curve()