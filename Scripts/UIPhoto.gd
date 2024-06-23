extends Node2D

var photoTexture = null;
var photoScale : Vector2 = Vector2(0, 0)
var focus : String = ""

var hideTransform : Transform2D = Transform2D(deg_to_rad(randi_range(-45,45)), Vector2(randi_range(700,1000), randi_range(900,1200)))
var showTransform : Transform2D = Transform2D(deg_to_rad(randi_range(20,-20)), Vector2(randi_range(700,1000), randi_range(200,475)))
var targetTransform : Transform2D = hideTransform

var isMoving : bool = false
var startMovePos : Vector2
static var zTop : int = 1

var isAttachedReport : bool = false

@onready var Photos = get_parent()
@onready var Background = $Background
@onready var PhotoSprite = $PhotoSprite
@onready var FocusLabel = $FocusLabel
@onready var Timestamp = $Timestamp

var speed = 0.1
var hiddenCounter = 0.0

func _ready():
	var time = get_tree().root.get_child(0).time
	var currentDay:int = (time/PI*12 + 2)/24
	var currentTime:float = fmod(time/PI*12 + 1, 12) + 1
	var currentHour:int = floor(currentTime)
	var currentMin:int = floor((currentTime - currentHour) * 60)
	Timestamp.text = "Day " + str(currentDay).pad_zeros(2) + ", " + str(currentHour) + ":" + str(currentMin).pad_zeros(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !PhotoSprite.texture:
		FocusLabel.text = focus
		PhotoSprite.scale = Vector2(1.8, 1.8) / photoScale
		PhotoSprite.texture = photoTexture
		
func _physics_process(delta) -> void:
	
	if speed < 3:
		speed += delta * speed * 3
		if speed > 3:
			speed = 3
			
	if hiddenCounter < 3:
		hiddenCounter += delta
		if hiddenCounter > 3:
			hiddenCounter = 3
			zTop = 0
			self.z_index = 0
	
	if !isMoving:
		self.transform = self.transform.interpolate_with(targetTransform, delta * speed)

func _on_button_button_up():
	if get_global_mouse_position().x < 50 and self.position.x < 100:
		self.queue_free()
	showTransform = targetTransform
	isMoving = false

func _on_button_button_down():
	if targetTransform != hideTransform:
		self.z_index = zTop
		if not isAttachedReport:
			Photos.move_child(self, Photos.get_child_count())
		zTop += 1
		startMovePos = get_global_mouse_position()
		isMoving = true
	
func _input(event):
	if isMoving and event is InputEventMouseMotion:
		var mPos = get_global_mouse_position()
		self.position += mPos - startMovePos
		startMovePos = mPos
		targetTransform = self.transform
		if get_global_mouse_position().x < 50 and self.position.x < 100:
			Background.modulate = Color(1, 0.5, 0.5)
			

func setShown(isShown : bool, isReport : bool = false):
	if isReport or not isAttachedReport:
		if isShown:
			targetTransform = showTransform
		else:
			targetTransform = hideTransform
			hiddenCounter = 0

func _on_area_2d_area_entered(area):
	if(area.is_in_group("Report")):
		var Report = area.get_parent()
		if Report.photoArray.size() < 3:
			Background.modulate = Color(0.75,1,0.75)
			isAttachedReport = true
			hideTransform = Transform2D(self.rotation, Vector2(370, 1000))
			Report.photoArray.append(self)


func _on_area_2d_area_exited(area):
	if(area.is_in_group("Report")):
		Background.modulate = Color(1, 1, 1)
		isAttachedReport = false
		hideTransform = Transform2D(deg_to_rad(randi_range(-45,45)), Vector2(randi_range(700,1000), randi_range(900,1200)))
		showTransform = Transform2D(deg_to_rad(randi_range(20,-20)), Vector2(randi_range(700,1000), randi_range(200,475)))
		area.get_parent().photoArray.erase(self)
