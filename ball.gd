extends CharacterBody2D

@export var angular_speed: float = 20
@export var speed: float = 1000
@export var paddle_influence: float = 0.3 # Controls how much paddle movement affects the ball's bounce

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	add_to_group("ball")


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	rotation_degrees += angular_speed * delta
# 	position += velocity * delta

func _on_start_button_pressed():
	print("button pressed")
	start()

func _unhandled_key_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		start()

func start():
	var direction_skew: float  = 100
	velocity = Vector2(speed, direction_skew)
	set_process(true)
	set_physics_process(true)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)

	if collision:
		var collider = collision.get_collider()

		if collider.is_in_group("paddles"):
			# Add some of the paddle's velocity to influence angle
			velocity = velocity.bounce(collision.get_normal())
			velocity.y += collider.velocity.y * paddle_influence
			velocity = velocity.normalized() * speed  # Maintain constant speed
		else:
			# Normal bounce for walls
			velocity = velocity.bounce(collision.get_normal())
			velocity = velocity.normalized() * speed
