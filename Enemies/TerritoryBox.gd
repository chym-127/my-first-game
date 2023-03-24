extends Area2D

#通用的领地BOX

var player = null

func can_see_player():
	return player != null

func _on_area_entered(area):
	player = area

func _on_area_exited(area):
	player = null
