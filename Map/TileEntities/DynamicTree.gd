@tool
extends Node3D

class_name DynamicTree

@onready var path_3d = $Path3D

@export var seed : int = 0
@export_range(0,1) var height : float = 1
@export_range(0,1) var width : float = 1
@export_range(0,1) var ratio : float = 1
@export_range(0,10) var detail : int = 10
@export var size : Vector3 = Vector3(1,1,1)
@export var update : bool = false

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_generate()
	

func _generate():
	print("regenerating")
	random.seed = seed
	#revert any existing changes
	path_3d.curve.clear_points()
	#generate trunk
	var target = Vector3(width*size.x,height*(size.y/2),width*size.z)
	var last_pos = Vector3(position)
	for d in range(detail):
		print(last_pos)
		var new_point = last_pos.move_toward(target, ratio)
		last_pos = new_point
		path_3d.curve.add_point(path_3d.position - new_point)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if update:
		update = false
		_generate()
