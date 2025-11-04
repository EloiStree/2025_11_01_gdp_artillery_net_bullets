extends Node3D
class_name DebugBallisticLine3D

@onready var mesh_instance := MeshInstance3D.new()
@onready var mesh := ImmediateMesh.new()

@export var points: Array[Vector3] = []


func _init(_points: Array[Vector3] = []):
	points = _points


func _ready():
	mesh_instance.mesh = mesh
	add_child(mesh_instance)

	# Create unlit yellow material
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(1.0, 1.0, 0.0)  # bright yellow
	mesh_instance.material_override = mat
	draw_line()

func set_points(_points: Array[Vector3]) -> void:
	points = _points
	draw_line()


func draw_line():
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	for point in points:
		mesh.surface_add_vertex(point)
	mesh.surface_end()
