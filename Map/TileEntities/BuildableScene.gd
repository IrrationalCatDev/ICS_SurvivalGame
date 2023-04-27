extends Node3D

class_name BuildableScene
## A buildable which manages the display/placement of objects into the world
##
## The intent of this scene is to compartmentalize the process of building objects and abstracting
## it to the point where an external scene merely needs to provide the target location and the object
## to build and the scene will handle the rest
##
## Some complications to work out:
## enable/disable the building process
## display the target buildable in the world as a ghost
## switch between buildables
## actually create real objects in the world
##
##
## Some things not handled by this scene:
## deconstruction/damage
## saving the objects into the world

#@export var buildables : Array[BuildableObject]
@onready var foundation = preload("res://Map/TileEntities/BuildableObjects/BuildableFoundation.tscn")


## displays a ghost of the buildable in the desired location
func preview(target : Vector3, buildable : Node3D) -> bool:
	if not buildable:
		return false
	if buildable not in get_children():
		add_child(buildable)
	
	target.y += buildable.size.y/2
	buildable.position = target
	buildable.preview()
	return true

## place the currently selected buildable in the desired location
func place(target : Vector3, buildable : Node3D) -> bool:
	if not buildable:
		return false
	if buildable not in get_children():
		add_child(buildable)
	
	target.y += buildable.size.y/2
	buildable.position = target
	buildable.place()	
	buildable.use_collision = true
	buildable = null
	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
