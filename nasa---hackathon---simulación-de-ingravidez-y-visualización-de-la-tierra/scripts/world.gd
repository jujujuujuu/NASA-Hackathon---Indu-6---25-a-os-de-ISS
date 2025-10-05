extends Node3D

var tween

func _ready():
	while true:
		$Earth.rotation.y = 0
		
		tween = create_tween()
		tween.set_trans(Tween.TRANS_LINEAR)
		
		tween.tween_property($Earth, "rotation:y", deg_to_rad(359), 86400)
		tween.parallel().tween_property($Earth/Clouds, "rotation:y", deg_to_rad(359), 43200)
		await get_tree().create_timer(43200).timeout
		tween.parallel().tween_property($Earth/Clouds, "rotation:y", deg_to_rad(359), 43200)
		await get_tree().create_timer(43200).timeout
