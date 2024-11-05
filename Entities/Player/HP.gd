## Requires a collision object as a parent.
class_name HP extends Node

@export var hit_points: int = 1

func hit(attack_damage: int) -> void:
  hit_points -= attack_damage
  if hit_points <= 0:
    get_parent().queue_free()