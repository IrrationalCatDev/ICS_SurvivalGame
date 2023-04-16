extends Node2D

@export var spriteSource : Sprite2D = null
@export var resourceStat : ResourceStat = null
@export var resourceStates : Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var currentPercent = resourceStat.CurrentResourceValue / resourceStat.MaximumResourceValue
	var divisions = resourceStates.size()
	for i in range(divisions,0,-1):
		if (1.0/divisions)*i > currentPercent:
			spriteSource.frame = resourceStates[i-1]
#	if currentPercent > .75:
#		frame = 69
#	elif currentPercent > .50:
#		frame = 68
#	else:
#		frame = 67
