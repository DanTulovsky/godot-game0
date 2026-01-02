extends Sprite2D

@export var rotation_speed: float = 5.0 # Degrees per second

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init():
	print("Icon initialized")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Convert degrees per second to radians per frame
	# rotation += deg_to_rad(rotation_speed * delta)
	rotation_degrees += rotation_speed * delta
