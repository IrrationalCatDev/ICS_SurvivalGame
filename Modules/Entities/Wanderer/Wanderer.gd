extends EntityBase

var move = load_ability("Move")

var wander_dir : int = 0
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	print("ready")
	
func wander():
	match(wander_dir):
		0: move.execute(self, 'up')
		1: move.execute(self, 'down')
		2: move.execute(self, 'left')
		3: move.execute(self, 'right')
			

func _physics_process(_delta):
	velocity = Vector2()
	
	match(int(random.randf()*20)):
		0:
			wander_dir = int(random.randf()*4)
	wander()
