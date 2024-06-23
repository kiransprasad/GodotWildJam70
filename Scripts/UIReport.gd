extends Node2D

const hideY : int = 1000
const showY : int = 340
var targetY : int = hideY

var photoArray = Array()

@onready var DescLabel = $DescriptionLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true
	
func _process(delta):
	DescLabel.text = "Proof of existence and impact on forest: " + str(photoArray.size()) + "/3"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.position.y = lerpf(self.position.y, targetY, delta * 3)

func setShown(isShown : bool):
	targetY = showY if isShown else hideY

