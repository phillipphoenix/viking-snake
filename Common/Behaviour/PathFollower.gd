class_name PathFollower extends Node

@export var navigation_agent: NavigationAgent2D
@export var path: Array[Node2D] = []:
	set(new_path):
		path = new_path
		current_path_index = -1

var current_path_index: int = -1

## Sets the next point in path as the navigation target. Returns true if there is a next target, false otherwise.
func goto_next_target() -> bool:
	current_path_index += 1
	if current_path_index >= path.size():
		return false
	var target = path[current_path_index]
	navigation_agent.set_target_position(target.global_position)
	return true