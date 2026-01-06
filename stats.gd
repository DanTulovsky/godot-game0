extends Node


var health: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("health: ", Stats.health)
	Stats.health = 200
	print("health: ", Stats.health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
