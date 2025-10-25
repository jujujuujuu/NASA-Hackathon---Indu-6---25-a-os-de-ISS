extends Node3D

var current_scene

func tween_trans(val: float) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($TransitionRect, "color:a", val, 2)
	tween.parallel().tween_property($Music, "volume_linear", 1-val, 2)
	await get_tree().create_timer(2).timeout

func switch_scene(scene: String, skip_fade_in: bool) -> void:
	if skip_fade_in:
		$TransitionRect.color.a = 1.0
		$Music.volume_linear = 0.0
	else:
		await tween_trans(1.0)
	
	$Music.stream_paused = true
	
	var new_scene = load("res://scenes/"+scene+".tscn") as PackedScene
	var instantiated_scene = new_scene.instantiate()
	if current_scene:
		remove_child(current_scene)
	add_child(instantiated_scene)
	if current_scene:
		current_scene.queue_free()
	current_scene = instantiated_scene
	
	$Music.stream_paused = false
	await tween_trans(0.0)

func _ready() -> void:
	$Music.play()
	switch_scene("start", true)
	Global.switch_scene.connect(switch_scene)
