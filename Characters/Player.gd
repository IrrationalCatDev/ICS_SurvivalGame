extends CharacterBody2D

class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var last_x = 0
var right = true
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var camera = $Camera2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
const run_speed_mult = 2

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority():
		return
	camera.make_current()

func _physics_process(_delta):
	if not is_multiplayer_authority():
		return
		
	var inputVel = Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up", "ui_down"))
	velocity = inputVel.normalized() * SPEED

	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	if velocity.length_squared() > 0:
		animation_player.play("Walk")
	else:
		animation_player.play("Idle")
	move_and_slide()
