extends CharacterBody3D

#@onready var camera_mount = $camera_mount
@onready var camera_scene = $CameraScene
@onready var character_graphics = $character_graphics

@onready var buildable_wall = preload("res://Map/TileEntities/BuildableObjects/BuildableWall.tscn")
@onready var buildable_foundation = preload("res://Map/TileEntities/BuildableObjects/BuildableFoundation.tscn")
var buildable_object

const SPEED = 5.0
const JUMP_VELOCITY = 10

var build_mode : bool = false

const run_speed_modifier = 3
var speed_mod : float = 1.0
@export var camera_min : float = -1
@export var camera_max : float = 1
@export var builder_scene : BuildableScene

@export var inventory_data : InventoryData
signal toggle_inventory

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting('physics/3d/default_gravity')
var was_on_floor : bool

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_scene.position.x = 0.5
	

func _input(event):
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-deg_to_rad(event.relative.x)/4)
		camera_scene.gimbal_rotate_x(-deg_to_rad(event.relative.y)/4)
		#camera_mount.rotate_x(-deg_to_rad(event.relative.y)/4)
		#camera_mount.rotation.x = clamp(camera_mount.rotation.x,camera_min,camera_max)
		if build_mode:
			var collision = camera_scene.get_collision_point()
			builder_scene.preview(collision, buildable_object)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var collision = camera_scene.get_collision_point()
			builder_scene.place(collision, buildable_object)
			buildable_object = null
			build_mode = false
	elif event is InputEventKey and event.is_pressed():
		#key pressed
		match event.get_physical_keycode_with_modifiers():
			KEY_1:
				build_mode = true
				if buildable_object:
					buildable_object.queue_free()
				buildable_object = buildable_foundation.instantiate()
				print('1')
			KEY_2:
				print('2')
				build_mode = true
				if buildable_object:
					buildable_object.queue_free()
				buildable_object = buildable_wall.instantiate()
			KEY_3:
				print('3')
			KEY_4:
				print('4')
			KEY_5:
				print('5')
			KEY_R:
				if buildable_object:
					buildable_object.rotation.y += PI/4
		var collision = camera_scene.get_collision_point()
		builder_scene.preview(collision, buildable_object)

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_access_inventory"):
		interact()
		
func interact():
	var collision = camera_scene.get_interact_collision()
	if collision:
		collision.player_interact()
	else:
		toggle_inventory.emit()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_released('ui_mouse_wheel_up'):
		camera_scene.camera_zoom(-1)
	elif Input.is_action_just_released('ui_mouse_wheel_down'):
		camera_scene.camera_zoom(1)
	if Input.is_action_just_pressed('ui_quit'):
		get_tree().quit()
		
	# Handle Jump.
	if Input.is_action_just_pressed('ui_accept') and is_on_floor():
		velocity.y = JUMP_VELOCITY
		character_graphics.jump()
		
	var sprint_dir = -1
	if Input.is_action_pressed('ui_shift') and is_on_floor():
		sprint_dir = 1
	speed_mod = clamp(speed_mod+(0.2*sprint_dir),1.0,run_speed_modifier)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	character_graphics.set_move(input_dir)
	character_graphics.set_is_running(sprint_dir == 1)
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED * speed_mod
			velocity.z = direction.z * SPEED * speed_mod
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * speed_mod)
			velocity.z = move_toward(velocity.z, 0, SPEED * speed_mod)
			

	move_and_slide()

func get_drop_position() -> Vector3:
	var direction = -camera_scene.camera_3d.global_transform.basis.z
	return global_position + direction
