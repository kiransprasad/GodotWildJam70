extends Node2D

var time:float = -4.8

@onready var DayNightCycle = $DayNightCycle
@onready var Watch = $CanvasLayer/UI_Watch

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	time += delta / 120
	DayNightCycle.tick(time)
	Watch.tick(time)
