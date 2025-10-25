extends Node3D

func _process(delta: float) -> void:
	$Mesh.rotation_degrees.y += 0.1
	$Clouds.rotation_degrees.y += 0.15
