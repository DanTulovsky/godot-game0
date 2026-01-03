extends CharacterBody2D

@export var angular_speed: float = 20
@export var speed: float = 1000
@export var max_speed: float = 10000
@export var speed_increase_rate: float = 10 # Speed increase per second
@export var paddle_influence: float = 0.3 # Controls how much paddle movement affects the ball's bounce

var current_speed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	add_to_group("ball")
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)


func _on_screen_exited():
	print("screen exited")
	position = get_viewport_rect().get_center()
	velocity = Vector2.ZERO
	current_speed = speed  # Reset speed to default
	set_physics_process(false)

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
	current_speed = speed  # Initialize current speed to default
	velocity = Vector2(current_speed, direction_skew)
	set_process(true)
	set_physics_process(true)

func _physics_process(delta):
	# Increase speed over time
	current_speed += speed_increase_rate * delta
	current_speed = clamp(current_speed, 0, max_speed)

	var collision = move_and_collide(velocity * delta)

	if collision:
		var collider = collision.get_collider()
		play_collision_sound()

		if collider.is_in_group("paddles"):
			# Add some of the paddle's velocity to influence angle
			velocity = velocity.bounce(collision.get_normal())
			velocity.y += collider.velocity.y * paddle_influence
			velocity = velocity.normalized() * current_speed  # Maintain current speed
		else:
			# Normal bounce for walls
			velocity = velocity.bounce(collision.get_normal())
			velocity = velocity.normalized() * current_speed

func play_collision_sound():
	$AudioStreamPlayer2D.play()
