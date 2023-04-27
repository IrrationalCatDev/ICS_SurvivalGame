extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree

var last_dir : Vector2 = Vector2.ZERO

var last_playing : String

func play_animation(anim : String):
	if anim == last_playing:
		return
	last_playing = anim
	animation_player.play(anim)
	
func set_is_running(run : bool):
	animation_tree['parameters/run_transition/transition_request'] = 'running' if run else 'not_running'

func set_move(dir : Vector2):
	last_dir = last_dir.lerp(dir,.1)
	animation_tree['parameters/run/blend_position'] = last_dir
	animation_tree['parameters/walk/blend_position'] = last_dir
	
func jump():
	animation_tree['parameters/OneShot/request'] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
