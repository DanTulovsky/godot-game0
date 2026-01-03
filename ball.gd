extends AnimatableBody2D

var angular_speed: float = 20
var direction: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += angular_speed * delta
	var velocity: Vector2 = Vector2.RIGHT * 1000 * direction
	position += velocity * delta

func _on_start_button_pressed():
	print("button pressed")
	set_process(true)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		set_process(true)

func _on_paddle_0_body_entered(body: AnimatableBody2D):
	print("hit paddle", body)
	direction = direction * -1
