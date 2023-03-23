extends CharacterBody2D

const MAX_SPEED = 80.0
const ACCELERATION = 500.0
const FRICTION = 500.0


@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	update_animation(Vector2(0,1))

func _physics_process(delta):
	move_state(delta)
	
#	处理移动
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position",input_vector)
		animationTree.set("parameters/Run/blend_position",input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION*delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION * delta)
	update_animation(input_vector)
	move_and_slide()
	
#	更新动画
func update_animation(move_vec:Vector2):
	if move_vec != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position",move_vec)
		animationTree.set("parameters/Run/blend_position",move_vec)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
	
