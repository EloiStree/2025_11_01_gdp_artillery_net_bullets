extends Node

@export var materials_to_affect:Array[Material]=[]
@export var mesh_instance_to_affect:Array[MeshInstance3D]=[]

## make it color not alpha
@export var color_to_set:=Color.RED
@export var use_random_color_at_ready:bool=true

func set_color(given_color:Color) -> void:
	if materials_to_affect.size() > 0:        
		for mat in materials_to_affect:
			if mat is Material:
				var material:Material=mat
				if material is StandardMaterial3D:
					var standard_material:StandardMaterial3D=material
					standard_material.albedo_color=given_color
				elif material is ShaderMaterial:
					var shader_material:ShaderMaterial=material
					shader_material.set_shader_parameter("albedo_color",given_color)
	if mesh_instance_to_affect.size() > 0:
		for mesh_instance in mesh_instance_to_affect:
			if mesh_instance is MeshInstance3D:
				var mi:MeshInstance3D=mesh_instance
				var surface_count:int=mi.mesh.get_surface_count() if mi.mesh else 0
				for surface_index in surface_count:
					var material:Material=mi.get_active_material(surface_index)
					if material is StandardMaterial3D:
						var standard_material:StandardMaterial3D=material
						standard_material.albedo_color=given_color
					elif material is ShaderMaterial:
						var shader_material:ShaderMaterial=material
						shader_material.set_shader_parameter("albedo_color",given_color)
						
func _ready() -> void:
	if use_random_color_at_ready:
		color_to_set = Color(randf(), randf(), randf(), 1.0)
	set_color(color_to_set)
	
	
