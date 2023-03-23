extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_down"):
		var scene = get_tree().current_scene
		var GrassDeathEffect = load("res://Effects/grass_death_effect.tscn")
		var grassDeathEffect =  GrassDeathEffect.instantiate()
		grassDeathEffect.global_position = global_position
		scene.add_child(grassDeathEffect)
		queue_free()
