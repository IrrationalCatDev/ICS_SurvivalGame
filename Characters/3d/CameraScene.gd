extends Node3D

@onready var outer_gimbal = $OuterGimbal
@onready var inner_gimbal = $OuterGimbal/InnerGimbal
@onready var camera_3d = $OuterGimbal/InnerGimbal/camera_pos
@onready var ray_cast = $OuterGimbal/InnerGimbal/Camera3D/RayCast3D

@export var x_clamp : Vector2
@export var y_clamp : Vector2
@export var cam_dist_clamp : Vector2

func _ready():
	gimbal_rotate_x(0)
	gimbal_rotate_y(0)
	camera_zoom(0)

func gimbal_rotate_x(xdelta : float):
	inner_gimbal.rotate_x(xdelta)
	inner_gimbal.rotation.x = clamp(inner_gimbal.rotation.x,x_clamp.x,x_clamp.y)

func gimbal_rotate_y(ydelta : float):
	outer_gimbal.rotate_y(ydelta)
	outer_gimbal.rotation.y = clamp(outer_gimbal.rotation.y,y_clamp.x,y_clamp.y)

func camera_zoom(dist : float):
	camera_3d.position.z = clamp(camera_3d.position.z+dist,cam_dist_clamp.x,cam_dist_clamp.y)
	
func get_collision_point():
	return ray_cast.get_collision_point()
