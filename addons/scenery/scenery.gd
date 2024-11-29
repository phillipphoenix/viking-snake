extends Node

@export var _2d_scene_root: Node2D
@export var _3d_scene_root: Node3D
@export var _ui_scene_root: Control

@export var _scene_items: Array[SceneItem] = []
@export var _init_scene_key: String = ""

var _scene_item_dict: Dictionary = {}

func _ready() -> void:
  for scene_item in _scene_items:
    _scene_item_dict[scene_item.key] = scene_item

  if _init_scene_key != "" or _init_scene_key != null:
    switch_to(_init_scene_key)

func switch_to(scene_item_key: String, data = null) -> void:
  var scene_item := _scene_item_dict[scene_item_key] as SceneItem
  assert(scene_item != null, "Scene item with key " + scene_item_key + " not found!")

  SceneryLog.log("Switching to scene item with key: " + scene_item_key)

  SceneryLog.log("Cleaning up children.")
  _remove_all_children(_2d_scene_root)
  _remove_all_children(_3d_scene_root)
  _remove_all_children(_ui_scene_root)

  SceneryLog.log("Instantiating scene item.")
  var scene_instance = scene_item.scene.instantiate()

  if scene_instance.has_method("scenery_init"):
    SceneryLog.log("Initialising scene with data.")
    scene_instance.scenery_init(data)

  SceneryLog.log("Adding scene item to corresponding root node.")
  match scene_item.type:
    SceneItem.SceneType.SCENE_2D:
      _2d_scene_root.add_child(scene_instance)
    SceneItem.SceneType.SCENE_3D:
      _3d_scene_root.add_child(scene_instance)
    SceneItem.SceneType.SCENE_UI:
      _ui_scene_root.add_child(scene_instance)

func _remove_all_children(node: Node) -> void:
  for child in node.get_children():
    node.remove_child(child)
    child.queue_free()