extends Node

var orbit_data = []

func _ready():
	var text = FileAccess.open("res://scripts//orbit_data.txt", FileAccess.READ).get_as_text()
	var lines = text.split("\n")
	
	for line in lines:
		var data = line.split(" ")
		var processed_data = []
		processed_data.append(data[0])
		for i in range(1, 7):
			processed_data.append(data[i])
		
		orbit_data.append(processed_data)
