extends Node3D

func _ready():
	for mango in range(1, 4):
		print(Orbit.orbit_data[mango])
