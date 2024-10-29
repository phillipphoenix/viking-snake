class_name ItemOptionButton extends OptionButton

var item_options: Array[ItemOption] = []:
	set(new_items):
		item_options = new_items
		for i in range(item_options.size()):
			add_item(item_options[i].label, i)
			set_item_icon(i, item_options[i].icon)
		selected = -1

var selected_item:
	get:
		if item_options.is_empty():
			return null
		return item_options[selected] if selected >= 0 else null

func get_item(index: int):
	return item_options[index]