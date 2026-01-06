extends Node

var current_scene: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_scene = get_tree().current_scene
	print("current_scene: ", current_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
