class_name SetMeshInstance3DColor
extends Node

@export var materials_to_affect: Array[Material] = []
@export var mesh_instance_to_affect: Array[MeshInstance3D] = []

@export var color_to_set := Color.RED
@export var use_random_color_at_ready: bool = true


func set_color(given_color: Color) -> void:
	# Directly assigned materials
	for mat in materials_to_affect:
		if mat is StandardMaterial3D:
			mat.albedo_color = given_color
		elif mat is ShaderMaterial:
			mat.set_shader_parameter("albedo_color", given_color)

	# MeshInstance3D materials
	for mi in mesh_instance_to_affect:
		if not mi or not mi.mesh:
			continue

		var surface_count := mi.mesh.get_surface_count()

		for surface_index in range(surface_count):

			var mat := mi.get_active_material(surface_index)

			# ----------------------------------------------------
			# CREATE UNLIT MATERIAL IF NONE EXISTS
			# ----------------------------------------------------
			if mat == null:
				mat = StandardMaterial3D.new()
				mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
				mat.albedo_color = given_color
				mi.set_surface_override_material(surface_index, mat)
				continue

			# ----------------------------------------------------
			# DUPLICATE MATERIAL (avoid shared materials)
			# ----------------------------------------------------
			mat = mat.duplicate()
			mi.set_surface_override_material(surface_index, mat)

			# ----------------------------------------------------
			# APPLY COLOR
			# ----------------------------------------------------
			if mat is StandardMaterial3D:
				mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
				mat.albedo_color = given_color

			elif mat is ShaderMaterial:
				mat.set_shader_parameter("albedo_color", given_color)



func _ready() -> void:
	await get_tree().process_frame
	randomize()

	if use_random_color_at_ready:
		color_to_set = Color(randf(), randf(), randf(), 1.0)

	set_color(color_to_set)
