## Requires a collision object as a parent.
class_name HP extends Node

@export var hit_points: int = 1
@export var death_scene: PackedScene

func hit(attack_damage: int) -> void:
	hit_points -= attack_damage
	if hit_points <= 0:
		if death_scene != null:
			var instance: Node2D = death_scene.instantiate()
			instance.global_position = get_parent().global_position
			GameManager.level.add_child(instance)
		get_parent().queue_free()
