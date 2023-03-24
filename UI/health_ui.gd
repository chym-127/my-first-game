extends Control

var hearts = 4:
	set(value):
		hearts = clamp(value,0,max_hearts)
		if label != null:
			label.text = "HP = " + str(hearts)

var max_hearts = 4:
	set(value):
		max_hearts = max(value,1)
		
@onready var label = $Label

func change_hearts(val):
	hearts = val

func _ready():
	max_hearts = PlayerStats.max_health
	hearts = PlayerStats.health
	PlayerStats.connect("health_changed",Callable(self,"change_hearts"))
	

