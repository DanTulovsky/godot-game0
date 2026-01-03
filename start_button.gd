extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	var timer: Timer = get_node("Timer")
	timer.timeout.connect(_on_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	# print("timer fired")
	pass
