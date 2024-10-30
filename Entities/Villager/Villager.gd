class_name Villager extends CharacterBody2D

@export var _villager_sprites: Array[Texture2D] = []

@export var _sprite: Sprite2D

func _ready() -> void:
	if _villager_sprites.size() > 0:
		_sprite.texture = _villager_sprites.pick_random()
