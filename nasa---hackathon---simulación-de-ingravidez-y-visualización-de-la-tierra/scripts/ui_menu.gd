extends Control

func _on_mouse_enter(button: Button) -> void:
	var tween = button.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(button, "modulate:a", 1.0, 0.5)
	tween.parallel().tween_property(button, "position:x", 75, 0.5)

func _on_mouse_exit(button: Button) -> void:
	var tween = button.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(button, "modulate:a", 0.6, 0.5)
	tween.parallel().tween_property(button, "position:x", 65, 0.5)

func _on_enter_button_pressed() -> void:
	Global.switch_scene.emit("world", false)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _ready():
	$EnterButton.mouse_entered.connect(_on_mouse_enter.bind($EnterButton))
	$EnterButton.mouse_exited.connect(_on_mouse_exit.bind($EnterButton))
	$QuitButton.mouse_entered.connect(_on_mouse_enter.bind($QuitButton))
	$QuitButton.mouse_exited.connect(_on_mouse_exit.bind($QuitButton))
