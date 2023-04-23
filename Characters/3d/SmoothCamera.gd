extends Camera3D


@onready var target = $"../camera_pos"
var update : bool = false
var gt_prev : Transform3D
var gt_current : Transform3D

func _ready():
	set_as_top_level(true)

func update_transform():
	gt_prev = gt_current
	gt_current = target.global_transform

func _process(delta):
	if update:
		update_transform()
		update = false
	
	var f = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)
	global_transform = gt_prev.interpolate_with(gt_current,f)

func _physics_process(_delta):
	update = true
