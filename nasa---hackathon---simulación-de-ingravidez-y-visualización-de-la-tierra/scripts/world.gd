extends Node3D

var height = 380
#var scale_factor = 0.5
var earth_size = 6371

func _init() -> void:
	$Earth.scale = Vector3(earth_size)
	
	

func _process(delta: float) -> void:
	$Earth.rotate_y(0 * delta)
	
