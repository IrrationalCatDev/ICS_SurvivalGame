extends EntityBase

var move = load_ability("Move")

func _ready():
	print("ready")

func _physics_process(_delta):
	velocity = Vector2()
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed('ui_up'): move.execute(self, 'up')
	if Input.is_action_pressed('ui_down'): move.execute(self, 'down')
	if Input.is_action_pressed('ui_left'): move.execute(self, 'left')
	if Input.is_action_pressed('ui_right'): move.execute(self, 'right')
