extends CharacterBody2D

@export_group("Speed")
@export var speed: float = 650.0
@export var rotation_speed: float = 1.5

@export_group("Misc")
@export var is_player: bool = false

@onready var ai_controller: AIController2D = $AIController2D

var rotation_direction: float = 0.0
var direction: int = 0 # -1 (down) to 1 (up)
var screen_size: Vector2
var ball: CharacterBody2D
var ai_target_rotation_direction: float = 0.0
var ai_rotation_change_timer: float = 0.0
var last_collision_frame: int = -1 # Track last collision frame to avoid duplicate rewards
var paddle_height: float = 200.0 # 100 pixels * 2x scale


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# Find the ball node using the "ball" group
	ball = get_tree().get_first_node_in_group("ball") as CharacterBody2D
	if not ball:
		printerr("No ball found")
		get_tree().quit(1)

	ball.game_over.connect(game_over)

	ai_controller.init(self)

	# IfAItraining is enabled, setthecontrolmodetotraining
	if Global.CONFIG.ai_training:
		ai_controller.control_mode = AIController2D.ControlModes.TRAINING
	elif is_player:
		ai_controller.control_mode = AIController2D.ControlModes.HUMAN
	else:
		print("setting ai controller control mode to ONNX_INFERENCE")
		ai_controller.control_mode = AIController2D.ControlModes.ONNX_INFERENCE


	print("paddle is human? ", is_player)
	print("ai controller control mode: ", ai_controller.control_mode)


func game_over():
	if not is_player:
		ai_controller.done = true
		ai_controller.needs_reset = true

func _physics_process(delta):
	match ai_controller.heuristic:
		"model":
			ai_mode(delta)
		"human":
			normal_mode(delta)

	# Lock horizontal movement - prevent paddle from drifting horizontally
	velocity.x = 0.0

	# Use move_and_slide() - paddles won't be pushed by the ball
	move_and_slide()

	# Check for collisions with the ball
	if ai_controller.heuristic == "model":
		_check_ball_collision()

func ai_mode(_delta):
	if ai_controller.needs_reset:
		ai_controller.reset()
		ball.reset()
		return

	# Get actions from the controller
	direction = ai_controller.vertical_action
	rotation_direction = ai_controller.rotation_action

	# Apply vertical movement
	velocity.y = direction * speed

	# Apply rotation
	rotation += rotation_direction * rotation_speed * _delta
	rotation = clamp(rotation, -0.3, 0.3)

func normal_mode(delta):
	if Input.is_action_pressed("ui_up"):
		direction = -1
	elif Input.is_action_pressed("ui_down"):
		direction = 1
	else:
		direction = 0

	rotation_direction = Input.get_axis("ui_left", "ui_right")
	rotation += rotation_direction * rotation_speed * delta
	rotation = clamp(rotation, -0.3, 0.3)

	velocity.y = direction * speed

func _check_ball_collision():
	if not ball:
		print("no ball found")
		return

	# Get the current frame number to avoid duplicate rewards
	var current_frame = Engine.get_process_frames()

	# Check if we have any collisions
	var collision_count = get_slide_collision_count()

	for i in range(collision_count):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		# Check if the collider is the ball
		if collider == ball:
			# Only reward once per collision event (avoid duplicate rewards in same frame)
			if last_collision_frame != current_frame:
				# Add reward for successfully hitting the ball
				# print("rewarding for hitting the ball")
				ai_controller.reward += 1.0
				last_collision_frame = current_frame
				break # Only count one collision per frame
