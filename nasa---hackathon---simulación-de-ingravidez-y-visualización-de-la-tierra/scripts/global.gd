extends Node

var orbit_data = []
var earth_radius = 6371
var mango = 0.0785

func _ready():
	var text = FileAccess.open("res://scripts//orbit_data.txt", FileAccess.READ).get_as_text()
	var lines = text.split("\n")
	
	for line in lines:
		var data = line.split(" ")
		
		if data.size()<6:
			continue
			
		var processed_data = []
		processed_data.append(data[0])
		processed_data.append(Vector3(
			float(data[1])*mango,
			float(data[2])*mango,
			float(data[3])*mango
		))
		processed_data.append(Vector3(
			float(data[4]),
			float(data[5]),
			float(data[6])
		))
		
		orbit_data.append(processed_data)
