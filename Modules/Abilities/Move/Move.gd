extends Node2D

func execute(s: EntityBase, dir):
	s.velocity = Vector2()
	
	if dir == 'up':
		s.velocity.y -= 1
	if dir == 'down':
		s.velocity.y += 1
	if dir == 'left':
		s.velocity.x -= 1
	if dir == 'right':
		s.velocity.x += 1
		
	s.velocity = s.velocity.normalized()
	s.velocity *= s.max_speed
	s.move_and_slide()
