extends CharacterBody2D

class_name EntityBase

var direction : Vector2 = Vector2()

var max_health : int = 100
var current_helth : int = 100

var max_speed : float = 200
var current_speed : float = 0
var acceleration : float = 4

@onready var navigation_agent = $NavigationAgent2D

func _physics_process(_delta):
	if not visible:
		return
		
	var move_direction = position.direction_to(navigation_agent.get_next_path_position())
	velocity = move_direction * max_speed
	navigation_agent.max_speed = max_speed
	navigation_agent.set_velocity(velocity)
	

func set_target_location(target:Vector2):
	navigation_agent.target_position = target
	
func _arrive_at_location():
	return navigation_agent.is_navigation_finished()

func load_ability(ability_name):
	var scene = load("res://Modules/Abilities/" + ability_name + "/" + ability_name + ".tscn")
	var sceneNode = scene.instantiate()
	add_child(sceneNode)
	return sceneNode



func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	if not _arrive_at_location():
		move_and_slide()
