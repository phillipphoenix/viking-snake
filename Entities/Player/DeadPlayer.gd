extends Node2D

@export var num_of_points: int = 50
@export var gravity: float = -9.8
@export var path: Path2D
@export var path_follower: PathFollow2D
@export var character_sprite: Sprite2D
@export var trajectory_line: Line2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_deferred_ready.call_deferred()

func _deferred_ready() -> void:
	var closest_target = _find_closest_target()
	_calculate_trajectory(closest_target.global_position)
	var tween := get_tree().create_tween()
	tween.tween_property(character_sprite, "scale", Vector2(0.4, 0.4), 1.5).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(character_sprite, "rotation_degrees", 3000, 2).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(path_follower, "progress_ratio", 1, 2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.finished.connect(_on_throw_finished)
	tween.play()

func _find_closest_target() -> Marker2D:
	var potential_targets = get_tree().get_nodes_in_group("DeadPlayerTarget")
	var closest_target: Marker2D = null
	var closest_target_dist: float = 10000000.0
	for potential_target in potential_targets:
		var dist_to_target = global_position.distance_squared_to(potential_target.global_position)
		if dist_to_target < closest_target_dist:
			closest_target_dist = dist_to_target
			closest_target = potential_target
	return closest_target as Marker2D

func _calculate_trajectory(target_position: Vector2) -> void:
	var points: Array[Vector2] = []
	var trajectory_curve = Curve2D.new()
	
	var dot = Vector2(1,0).dot((target_position - global_position).normalized())
	var angle = 90 - 45 * dot

	var dist_x := target_position.x - global_position.x
	var dist_y := -1.0 * (target_position.y - global_position.y)
	
	var speed = sqrt(((0.5 * gravity * dist_x * dist_x) / pow(cos(deg_to_rad(angle)), 2.0)) / (dist_y -(tan(deg_to_rad(angle)) * dist_x)))
	var x_component = cos(deg_to_rad(angle)) * speed
	var y_component = sin(deg_to_rad(angle)) * speed
	
	var total_time = dist_x / x_component
	
	
	for point in num_of_points:
		var time = total_time * (float(point) / float(num_of_points))
		var dx = time * x_component
		var dy = -1.0 * (time * y_component + 0.5 * gravity * time * time)
		points.append(Vector2(dx, dy))
		trajectory_curve.add_point(Vector2(dx, dy))
		
	trajectory_line.points = points
	path.curve = trajectory_curve

func _on_throw_finished() -> void:
	queue_free()
