extends Node3D

var iss_height = 380
var earth_radius = 6371
var earth_rot_speed = 5

func _process(delta: float) -> void:
	var angular_speed = earth_rot_speed/earth_radius
	
	$Earth.rotate_y(angular_speed * delta)
	
