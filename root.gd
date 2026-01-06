extends Node2D

var quit_dialog: ConfirmationDialog
var theme: Theme = Theme.new()


func _ready() -> void:
	quit_dialog = ConfirmationDialog.new()
	quit_dialog.dialog_text = "Are you sure you want to quit?"
	quit_dialog.size = Vector2(400, 150)
	quit_dialog.min_size = Vector2(400, 150)

	set_theme_params()

	quit_dialog.theme = theme
	add_child(quit_dialog)
	quit_dialog.confirmed.connect(_on_quit_confirmed)

	print(Stats.health)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not quit_dialog.visible:
			quit_dialog.popup_centered()


func _on_quit_confirmed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit(0)


func set_theme_params() -> void:
	# Set font size for Window class title (affects "Please Confirm..." text)
	theme.set_font_size("title_font_size", "Window", 24)

	# Set font size for Label class (affects dialog text)
	theme.set_font_size("font_size", "Label", 36)

	# Set font size for Button class (affects dialog buttons)
	theme.set_font_size("font_size", "Button", 30)
