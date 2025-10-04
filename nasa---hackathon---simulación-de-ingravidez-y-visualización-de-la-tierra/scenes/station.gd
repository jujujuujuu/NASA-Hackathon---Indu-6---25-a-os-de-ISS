extends Node3D

var tween

func _ready():
	position = Global.orbit_data[0][1]
		
	for i in Global.orbit_data.size():
		if i==0:
			continue
			
		tween = create_tween()
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "position", Global.orbit_data[i][1], 240)
		await get_tree().create_timer(240).timeout
