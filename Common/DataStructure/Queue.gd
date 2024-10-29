class_name Queue extends Object

var _queue: Array = []

func enqueue(item) -> void:
	_queue.append(item)

func dequeue() -> Object:
	if _queue.size() == 0:
		return null
	var item = _queue[0]
	_queue.remove_at(0)
	return item

func peek() -> Object:
	if _queue.size() == 0:
		return null
	return _queue[0]

func size() -> int:
	return _queue.size()

func is_empty() -> bool:
	return _queue.size() == 0