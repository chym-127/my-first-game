extends Node

@export var max_health:int=4
@onready var health = max_health:
	set(value):
		health = value
		emit_signal("health_changed",health)
		if  value <= 0:
			emit_signal("no_health")

signal no_health
signal health_changed



