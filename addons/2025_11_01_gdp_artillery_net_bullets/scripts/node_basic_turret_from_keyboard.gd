
class_name NodeBasicTurretFromKeyboard extends Node3D

@export var turret_to_affect:NodeBasicTurret

@export var input_get_new_position:String = "R"
@export var input_rotation_left:String = "A"
@export var input_rotation_right:String = "D"
@export var input_rotation_up:String = "W"
@export var input_rotation_down:String = "S"
@export var input_fire_bullet:String = "E"
@export var input_increase_velocity:String = "R"
@export var input_decrease_velocity:String = "F"

func _input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.pressed:
            if event.as_text() == input_get_new_position:
                turret_to_affect.request_turret_new_random_position()
            elif event.as_text() == input_rotation_left:
                turret_to_affect.bool_is_rotating_left = true
            elif event.as_text() == input_rotation_right:
                turret_to_affect.bool_is_rotating_right = true
            elif event.as_text() == input_rotation_up:
                turret_to_affect.bool_is_rotating_up = true
            elif event.as_text() == input_rotation_down:
                turret_to_affect.bool_is_rotating_down = true
            elif event.as_text() == input_fire_bullet:
                turret_to_affect.request_turret_to_fire_bullet()
        else:
            if event.as_text() == input_rotation_left:
                turret_to_affect.bool_is_rotating_left = false
            elif event.as_text() == input_rotation_right:
                turret_to_affect.bool_is_rotating_right = false
            elif event.as_text() == input_rotation_up:
                turret_to_affect.bool_is_rotating_up = false
            elif event.as_text() == input_rotation_down:
                turret_to_affect.bool_is_rotating_down = false