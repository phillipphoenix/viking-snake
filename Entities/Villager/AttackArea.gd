extends Area2D

@export var attack_damage: int = 1
@export var find_hp_recursive: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	var hp := find_hp(body, find_hp_recursive)
	if hp != null:
		hp.hit(attack_damage)


func find_hp(parent: Node, recursive: bool = true) -> HP:
	for child in parent.get_children():
			if child is HP:
					return child
			if recursive:
				var grandchild = find_hp(child)
				if grandchild != null:
						return grandchild
	return null
