class_name ItemOption extends RefCounted

var label: String = ""
var icon: Texture2D
var item

func _init(_label: String, _item) -> void:
	label = _label
	item = _item
	print("ItemOption created with item: ", item.name)

static func new_with_icon(_label: String, _icon: Texture2D, _item) -> ItemOption:
	var option = ItemOption.new(_label, _item)
	option.icon = _icon
	return option