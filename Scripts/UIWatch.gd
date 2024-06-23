extends Node2D

@onready var HourHand = $HourHand
@onready var MinuteHand = $MinuteHand

@export var HourSprite = []
@export var MinSprite = []

var Game

var prevMin:int = -1
var prevHour:int = -1

var prevTime = 0

const showTransform = Transform2D(Vector2(3.863704, -1.035275), Vector2(1.035275, 3.863704), Vector2(125, 325))
const hideTransform = Transform2D(Vector2(3.91259, 0.831649), Vector2(-0.831649, 3.91259), Vector2(400, 920))
var targetTransform = hideTransform;

func _ready():
	self.visible = true

func _process(delta) -> void:
	if !Game:
		Game = get_tree().root.get_child(0)
		return
		
	var time = Game.time
	var currentTime:float = fmod(time/PI*12 + 1, 12) + 1
	var currentHour:int = floor(currentTime)
	var currentMin:int = floor((currentTime - currentHour) * 12)
	
	if prevMin != currentMin:
		prevMin = currentMin
		MinuteHand.texture = MinSprite[currentMin % 3]
		MinuteHand.rotation = deg_to_rad(floor(currentMin/3.0) * 90)
		if prevHour != currentHour:
			prevHour = currentHour
			HourHand.texture = HourSprite[currentHour % 3]
			HourHand.rotation = deg_to_rad(floor(currentHour/3.0) * 90)
			
func _physics_process(delta) -> void:
	self.transform = self.transform.interpolate_with(targetTransform, delta * 3)
	
func setShown(isShown : bool):
	targetTransform = showTransform if isShown else hideTransform
