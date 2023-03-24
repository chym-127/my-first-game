extends CharacterBody2D

const MAX_SPEED = 80.0
const ACCELERATION = 500.0
const FRICTION = 500.0
const ROLL_SPEED = 80.0

enum {
	RUN,
	ROLL,
	ATTACK
}

@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var hitBoxArea = $hitBoxMark2
@onready var animationState = animationTree.get("parameters/playback")
var state = RUN

var stats = PlayerStats

var attack_vector = Vector2.ZERO

func _ready():
	stats.connect("no_health",Callable(self, "queue_free"))
	animationTree.active = true
	update_animation(Vector2(0,1))

func _physics_process(delta):
	match state:
		RUN:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)
	hitBoxArea.attack_vector = attack_vector
	
#	处理移动
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		attack_vector = input_vector
		velocity = velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION*delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION * delta)
		
	update_animation(input_vector)
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_select"):
		state = ROLL
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(delta):
	velocity = attack_vector*ROLL_SPEED
	animationState.travel("Roll")
	move_and_slide()

func attack_state(delta):
	animationState.travel("Attack")

#攻击动画结束
func on_attack_animation_finished():
	velocity = Vector2.ZERO	
	state = RUN

#翻滚动画结束
func on_roll_animation_finished():
	velocity = Vector2.ZERO	
	move_and_slide()
	state = RUN

#	更新动画
func update_animation(move_vec:Vector2):
	if move_vec != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position",move_vec)
		animationTree.set("parameters/Run/blend_position",move_vec)
		animationTree.set("parameters/Attack/blend_position",move_vec)
		animationTree.set("parameters/Roll/blend_position",move_vec)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
	

func show_hurt_effect():
	var scene = get_tree().current_scene
	var HurtEffect = load("res://Effects/hurt_effect.tscn")
	var hurtEffect = HurtEffect.instantiate()
	hurtEffect.global_position = global_position
	scene.add_child(hurtEffect)

func _on_hurt_box_area_entered(area):
	stats.health -= 1
	show_hurt_effect()
