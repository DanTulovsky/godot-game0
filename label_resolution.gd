extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str(get_viewport().get_visible_rect().size)
