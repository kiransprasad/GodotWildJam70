extends Node2D

var time:float = 2

@onready var DayNightCycle = $DayNightCycle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	time += delta / 120
	DayNightCycle.tick(time)
