class_name SpriteFlipper extends Node

@export var sprites: Array[Sprite2D] = []
@export var character_body: CharacterBody2D

@export var flip_h: bool = true
@export var flip_v: bool = false

func _process(_delta: float) -> void:
	for sprite in sprites:
		if flip_h:
			sprite.flip_h = character_body.velocity.x < 0
		if flip_v:
			sprite.flip_v = character_body.velocity.y < 0