extends Control

## This is emitted when the scene is finished loading.
## Use `ResourceLoader.load_threaded_get(path)` to get the scene.
signal scene_loaded(path: String)

@onready var progress_bar = %ProgressBar

## Actual progress value; we move towards towards this
var progress_value := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.hide()

func _on_button_pressed() -> void:
	progress_bar.show()
	ResourceLoader.load_threaded_request(Global.ROOT_SCENE)

func _process(delta: float):
	var path: String = Global.ROOT_SCENE

	if not path:
		return

	var progress = []
	var status = ResourceLoader.load_threaded_get_status(path, progress)

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		progress_value = progress[0] * 100
		progress_bar.value = move_toward(progress_bar.value, progress_value, delta * 20)

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		# zip the progress bar to 100% so we don't get weird visuals
		progress_bar.value = move_toward(progress_bar.value, 100.0, delta * 150)

		# "done" loading :)
		if progress_bar.value >= 99:
			scene_loaded.emit(path)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit(0)

func _on_scene_loaded(path: String) -> void:
	Global.goto_scene(path)
