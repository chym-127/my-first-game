extends CharacterBody2D


const SPEED = 50.0
const MAX_SPEED = 50
const ACCELERATION = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var back = Vector2.ZERO
var move_vec = Vector2.ZERO

@onready var stat = $stats
@onready var territoryBox = $TerritoryBox
@onready var sprite = $AnimatedSprite2D
@onready var softCollision = $SoftConllistion
enum {
	GOTO_PLAYER,
	SENTINEL,
	HIT,
	HURT
}

var state = SENTINEL

func _physics_process(delta):
	seek_player()
	match state:
		GOTO_PLAYER:
			move_to_player_state(delta)
		HIT:
			hit_state()
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	move_and_slide()

func seek_player():
	if territoryBox.can_see_player():
		state = GOTO_PLAYER
		
func hit_state():
	print("hit")

func move_to_player_state(delta):
	var player = territoryBox.player
	if player:
		move_vec = (player.global_position-global_position).normalized()
		velocity = velocity.move_toward(move_vec * MAX_SPEED,ACCELERATION * delta)
	else:
		move_vec = Vector2.ZERO
		state = SENTINEL
	sprite.flip_h = velocity.x < 0
		

func hurt_state(delta):
	if velocity == Vector2.ZERO:
		state = SENTINEL
	velocity = velocity.move_toward(Vector2.ZERO,200*delta)

func auto_attack():
	pass


func _on_territory_box_area_exited(area):
	state = SENTINEL

func show_hurt_effect():
	var scene = get_tree().current_scene
	var HurtEffect = load("res://Effects/hurt_effect.tscn")
	var hurtEffect = HurtEffect.instantiate()
	hurtEffect.global_position = global_position
	scene.add_child(hurtEffect)

func _on_hurt_box_area_entered(area):
	stat.health -= 1
	show_hurt_effect()
	velocity = area.attack_vector * 120
	
func _on_stats_no_health():
	queue_free()
