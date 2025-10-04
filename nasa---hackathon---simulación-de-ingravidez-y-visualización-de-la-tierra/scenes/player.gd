extends Node3D

const mouse_sensitivity = 0.002
var rotation_y = 0
var rotation_x = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	var pos_change = Vector3()
	
	if Input.is_action_pressed("ui_up"):
		pos_change += Vector3(0, 0, -1)
	if Input.is_action_pressed("ui_down"):
		pos_change += Vector3(0, 0, 1)
	if Input.is_action_pressed("ui_right"):
		pos_change += Vector3(1, 0, 0)
	if Input.is_action_pressed("ui_left"):
		pos_change += Vector3(-1, 0, 0)
	if Input.is_action_pressed("translate_up"):
		pos_change += Vector3(0, 1, 0)
	if Input.is_action_pressed("translate_down"):
		pos_change += Vector3(0, -1, 0)
		
	translate_object_local(pos_change.normalized()*delta*2)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
		
		rotation_degrees.y = rad_to_deg(rotation_y)
		rotation_degrees.x = rad_to_deg(rotation_x)
