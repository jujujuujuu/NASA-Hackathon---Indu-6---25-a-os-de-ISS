extends Node3D

const mouse_sensitivity = 0.002
var rotation_y = 0
var rotation_x = 0
var global_velocity = Vector3.ZERO
var offset = Vector3.ZERO
var max_velocity = 4

var flashlight = false
var in_cupola = true
var in_transition = false

@export var viewport_cam : Node3D
@export var UI : Control

func set_velocity(desired_velocity: Vector3) -> void:
	global_velocity = desired_velocity

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	position = get_parent().get_node("cupola").position - Vector3(0, 0, 0.07)
	rotation_degrees.y = get_parent().get_node("cupola").rotation_degrees.y - 180
	viewport_cam.global_transform = global_transform

func _process(delta: float) -> void:
	if in_cupola:
		viewport_cam.global_transform = global_transform
		return
	
	var acceleration = Vector3.ZERO
	
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
		global_velocity += viewport_cam.global_transform.basis * acceleration.normalized()/100
	else:
		global_velocity += viewport_cam.global_transform.basis * acceleration.normalized()/50
	
	global_velocity = global_velocity.clamp(Vector3(-max_velocity, -max_velocity, -max_velocity), Vector3(max_velocity, max_velocity, max_velocity))
	
	offset += global_velocity*delta
	viewport_cam.global_position = global_position + offset

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		
		if in_cupola:
			rotation_y = clamp(rotation_y, deg_to_rad(120), deg_to_rad(240))
			rotation_x = clamp(rotation_x, deg_to_rad(-60), deg_to_rad(60))
		else:
			rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
		
		rotation_degrees.y = rad_to_deg(rotation_y)
		rotation_degrees.x = rad_to_deg(rotation_x)
		viewport_cam.rotation_degrees = rotation_degrees

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel_movement"):
		var stop_tween = create_tween()
		stop_tween.set_trans(Tween.TRANS_LINEAR)
		
		stop_tween.tween_method(set_velocity, global_velocity, Vector3.ZERO, 2)
	elif event.is_action_pressed("interact") and not in_transition:
		in_transition = true
		var cupola = get_parent().get_node("cupola")
		var station = get_parent().get_node("station")
		var panel = UI.get_node("Panel").get("theme_override_styles/panel") as StyleBoxFlat
		
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(panel, "bg_color", Color(0, 0, 0, 1), 1)
		tween.parallel().tween_property($Camera3D, "fov", 40, 1)
		tween.parallel().tween_property(viewport_cam, "fov", 40, 1)
		
		await get_tree().create_timer(1).timeout
		
		in_cupola = not in_cupola
		
		if in_cupola:
			flashlight = false
			viewport_cam.get_node("Flashlight").hide()
			cupola.show()
			viewport_cam.get_node("Helmet").hide()
			station.hide()
			position = cupola.position - Vector3(0, 0, 0.07)
			UI.get_node("Interact").text = "[T] - Exit Cupola"
			UI.get_node("Controls").hide()
		else:
			global_velocity = Vector3.ZERO
			viewport_cam.get_node("Helmet").show()
			cupola.hide()
			station.show()
			UI.get_node("Interact").text = "[T] - Enter Cupola"
			UI.get_node("Controls").show()
		
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(panel, "bg_color", Color(0, 0, 0, 0), 1)
		tween.parallel().tween_property($Camera3D, "fov", 75, 1)
		tween.parallel().tween_property(viewport_cam, "fov", 75, 1)
		
		await get_tree().create_timer(1).timeout
		
		in_transition = false
	elif event.is_action_pressed("flashlight") and not in_cupola:
		flashlight = not flashlight
		if flashlight: viewport_cam.get_node("Flashlight").show()
		else: viewport_cam.get_node("Flashlight").hide()
