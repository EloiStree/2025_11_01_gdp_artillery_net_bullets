# class_name  BulletsPoolManagerNodeView extends Node3D

# @export var bullets_pool_manager: BulletsPoolManager
# @export var node_to_feed_the_pool: Node3D
# @export var max_bullets_in_pool: int = 100
# @export var map_size_multiplicator: float = 0.001
# @export var debug_bullets_size: float = 0.1

# var nodes_pool_of_bullets: Array[Node3D] = []


# func _ready() -> void:
#     for i in range(max_bullets_in_pool):
#         var bullet_instance = node_to_feed_the_pool.duplicate() as Node3D
#         bullet_instance.visible = false
#         add_child(bullet_instance)
#         nodes_pool_of_bullets.append(bullet_instance)

# func _process(delta: float) -> void:

#     var bullets = bullets_pool_manager.bullets_to_current_point
#     for i in range(bullets.size()):
#         if i >= nodes_pool_of_bullets.size():
#             break
#         var bullet = bullets[i]
#         var node_bullet = nodes_pool_of_bullets[i]
#         node_bullet.global_position = bullet.bullet_current_point * map_size_multiplicator
#         node_bullet.scale = Vector3(debug_bullets_size, debug_bullets_size, debug_bullets_size)
#         node_bullet.visible = true