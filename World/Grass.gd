extends Node2D

func _on_hurt_box_area_entered(_area):
	var scene = get_tree().current_scene
	var GrassDeathEffect = load("res://Effects/grass_death_effect.tscn")
	var grassDeathEffect =  GrassDeathEffect.instantiate()
	grassDeathEffect.global_position = global_position
	scene.add_child(grassDeathEffect)
	queue_free()
