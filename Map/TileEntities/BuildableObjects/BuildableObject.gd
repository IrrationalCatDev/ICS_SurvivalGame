extends CSGBox3D

class_name BuildableObject

#set the state of the buildable object to preview mode
func preview():
	print("preview")
	pass

#set the state of the buildable object to placed in the world
func place():
	print("place")
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
