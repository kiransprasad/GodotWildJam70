extends CharacterBody2D

@onready var Animator = $AnimatedSprite2D 

@export var walkSpeed = 75
@export var runSpeed = 200

enum STATE {
	IDLE,
	WALK,
	RUN,
	EAT
}

var animalState:STATE = STATE.IDLE

var wanderTimer:float = 0
var wanderDirection:Vector2 = Vector2(0, 0)
var eatTimer:float = 20
var isEatPosition:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Update Timers
	wanderTimer += delta
	eatTimer += delta
	
	# Change Animation State
	update_state()
	
	var direction = Vector2(0, 0)
	if animalState == STATE.WALK or animalState == STATE.RUN:
		direction = wanderDirection
	
	velocity = direction * (runSpeed if animalState == STATE.RUN else walkSpeed)
	move_and_slide()
	
	play_anim(direction)

func update_state():
	if animalState == STATE.IDLE:
		if eatTimer > 42:
			animalState = STATE.EAT
			eatTimer = -randf_range(5, 12)
			isEatPosition = false
		elif wanderTimer > 7 and not isEatPosition:
			animalState = STATE.WALK
			wanderTimer = -randf_range(1, 3)
			wanderDirection = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	elif animalState == STATE.WALK:
		if wanderTimer >= 0:
			animalState = STATE.IDLE
	elif animalState == STATE.EAT:
		if eatTimer >= 0:
			animalState = STATE.IDLE
			

func play_anim(direction):
	if animalState == STATE.IDLE:
		if isEatPosition:
			Animator.play("eat_end")
		else:
			Animator.play("idle")
	if animalState == STATE.WALK or animalState == STATE.RUN:
		if direction.x:
			Animator.set_flip_h(direction.x < 0)
		Animator.play("walk" if animalState == STATE.WALK else "run")
	if animalState == STATE.EAT:
		if not isEatPosition:
			Animator.play("eat_start")
		else:
			Animator.play("eat")
		

func _on_animated_sprite_2d_animation_finished():
	isEatPosition = !isEatPosition
