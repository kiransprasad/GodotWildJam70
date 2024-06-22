extends Node2D

var photoTexture = null;
var photoScale = Vector2(0, 0)
var focus = ""

var hideTransform = Transform2D(deg_to_rad(randi_range(-45,45)), Vector2(randi_range(600,1000), randi_range(900,1200)))
var targetTransform = hideTransform

var isMoved = false;

@onready var PhotoSprite = $PhotoSprite

func _ready():
	print(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !PhotoSprite.texture:
		PhotoSprite.scale = Vector2(1.8, 1.8) / photoScale
		PhotoSprite.texture = photoTexture
		
func _physics_process(delta) -> void:
	if Input.is_action_just_pressed("INVENTORY"):
		if(targetTransform == hideTransform):
			targetTransform = Transform2D(deg_to_rad(randi_range(-20,20)), Vector2(randi_range(550,950), randi_range(225,425)))
		else:
			targetTransform = hideTransform
			
	self.transform = self.transform.interpolate_with(targetTransform, delta * 3)

func _pressed():
	print("YUNX")
