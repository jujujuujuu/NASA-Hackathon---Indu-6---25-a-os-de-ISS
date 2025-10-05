extends Node3D

var tween
var orbit_offset = 5

func _ready():
	position = Global.orbit_data[orbit_offset][0]
		
	for i in Global.orbit_data.size():
		if i <= orbit_offset:
			continue
			
		tween = create_tween()
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "position", Global.orbit_data[i][0], 240)
		await get_tree().create_timer(240).timeout

func _process(delta: float) -> void:
	var earth = get_parent().get_node("Earth")
	var dir = earth.global_transform.origin - global_transform.origin
	dir = dir.rotated(Vector3.UP, deg_to_rad(180))
	look_at(global_transform.origin + dir, Vector3.UP)
	
