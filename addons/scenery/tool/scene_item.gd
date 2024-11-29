class_name SceneItem extends Resource

## A unique key used to identify the scene.
@export var key: String
@export var scene: PackedScene
@export var category: SceneCategory
@export var type: SceneType

## The type of scene indicates where it is instantiated in the tree.
enum SceneType {
    SCENE_2D,
    SCENE_3D,
    SCENE_UI,
}