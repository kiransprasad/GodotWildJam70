extends CharacterBody2D

@onready var Sprite = $Sprite2D
@onready var Animator = $AnimationPlayer

@export var walkSpeed = 75
@export var runSpeed = 200
@export var NAME = "?????"

enum STATE {
	IDLE,
	WALK,
	RUN,
	EAT,
	HOME
}

var animalState:STATE = STATE.IDLE

var wanderTimer:float = 0
var wanderDirection:Vector2 = Vector2(0, 0)
var eatTimer:float = 20
var isEatPosition:bool = false
var scareTimer:float = 0

var playerPosition = null
var homePosition = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Update Timers
	wanderTimer += delta
	eatTimer += delta
	if(scareTimer > 0):
		scareTimer -= delta
	
	# Change Animation State
	update_state()
	
	var direction = Vector2(0, 0)
	if animalState == STATE.WALK or animalState == STATE.RUN:
		direction = wanderDirection
	
	velocity = direction * (runSpeed if animalState == STATE.RUN else walkSpeed)
	move_and_slide()
	
	play_anim(direction)

func update_state():
	if animalState == STATE.HOME:
		if scareTimer == 0:
			animalState = STATE.WALK
	elif scareTimer > 0:
		animalState = STATE.RUN
		if homePosition:
			if position.distance_to(homePosition) < 10:
				animalState = STATE.HOME
				scareTimer = 10
			else:
				wanderDirection = self.position.direction_to(homePosition).normalized()
		else:
			wanderDirection = playerPosition.direction_to(self.position).normalized()
				
	if animalState == STATE.IDLE:
		if eatTimer > 42:
			animalState = STATE.EAT
			eatTimer = -randf_range(5, 12)
			isEatPosition = false
		elif wanderTimer > 7 and not isEatPosition:
			animalState = STATE.WALK
			wanderTimer = -randf_range(1, 3)
			wanderDirection = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	elif animalState == STATE.WALK:
		if wanderTimer >= 0:
			animalState = STATE.IDLE
	elif animalState == STATE.EAT:
		if eatTimer >= 0:
			animalState = STATE.IDLE
			

func play_anim(direction):
	self.visible = animalState != STATE.HOME
	if animalState == STATE.IDLE:
		if isEatPosition:
			Animator.play("eat_end")
		else:
			Animator.play("idle")
	if animalState == STATE.WALK or animalState == STATE.RUN:
		if direction.x:
			Sprite.scale.x = -1 if direction.x < 0 else 1
		Animator.play("walk" if animalState == STATE.WALK else "run")
	if animalState == STATE.EAT:
		if not isEatPosition:
			Animator.play("eat_start")
		else:
			Animator.play("eat")
		
		
func _on_animation_player_animation_finished(anim_name):
	isEatPosition = !isEatPosition

func scare(playerPos):
	playerPosition = playerPos
	scareTimer = 5

