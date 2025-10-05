extends Node3D

const mouse_sensitivity = 0.002
var rotation_y = 0
var rotation_x = 0
var velocity = Vector3.ZERO
var max_velocity = 6
var in_cupola = true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func set_velocity(desired_velocity: Vector3) -> void:
	velocity = desired_velocity

func _process(delta: float) -> void:
	if not in_cupola:
		var acceleration = Vector3(0, 0, 0)
		
		if Input.is_action_pressed("ui_up"):
			acceleration += Vector3(0, 0, -1)
		if Input.is_action_pressed("ui_down"):
			acceleration += Vector3(0, 0, 1)
		if Input.is_action_pressed("ui_right"):
			acceleration += Vector3(1, 0, 0)
		if Input.is_action_pressed("ui_left"):
			acceleration += Vector3(-1, 0, 0)
		if Input.is_action_pressed("translate_up"):
			acceleration += Vector3(0, 1, 0)
		if Input.is_action_pressed("translate_down"):
			acceleration += Vector3(0, -1, 0)
		
		if Input.is_action_pressed("slow_movement"):
			velocity += global_transform.basis * acceleration.normalized()/10
		else:
			velocity += global_transform.basis * acceleration.normalized()/5
			
		velocity = velocity.clamp(Vector3(-max_velocity, -max_velocity, -max_velocity), Vector3(max_velocity, max_velocity, max_velocity))
		global_translate(velocity*delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
		
		rotation_degrees.y = rad_to_deg(rotation_y)
		rotation_degrees.x = rad_to_deg(rotation_x)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel_movement"):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_EXPO)
		tween.set_ease(Tween.EASE_OUT)
		
		tween.tween_method(set_velocity, velocity, Vector3.ZERO, 3)
	elif event.is_action_pressed("interact"):
		in_cupola = not in_cupola
		var cupola = get_parent().get_node("cupola")
		
		if in_cupola:
			cupola.show()
			position = cupola.position
		else:
			cupola.hide()
