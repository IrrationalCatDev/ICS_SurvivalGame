extends Node2D

var dragging : bool = false
var highlighted : Array[EntityBase] = []
var drag_start : Vector2 = Vector2.ZERO
var select_rect : RectangleShape2D = RectangleShape2D.new()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				drag_start = get_global_mouse_position()
				dragging = true
			elif dragging:
				queue_redraw()
				dragging = false
				select()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			#send event to entity group?
			get_tree().call_group("Selected_Entities", "set_target_location",get_global_mouse_position())
			pass
			
			
	if event is InputEventMouseMotion and dragging:
		var drag_end = get_global_mouse_position()
		select_rect.extents = abs((drag_end - drag_start) / 2)
		var space = get_world_2d().direct_space_state
		var query = PhysicsShapeQueryParameters2D.new()
		query.set_shape(select_rect)
		query.transform = Transform2D(0,(drag_end+drag_start)/2)
		var results = space.intersect_shape(query)
		highlighted.clear()
		for result in results:
			highlighted.push_back(result['collider'])
		queue_redraw()
		
		


func select():
	get_tree().call_group("Selected_Entities", "remove_from_group","Selected_Entities")
	for target in highlighted:
		target.add_to_group("Selected_Entities")

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start,get_global_mouse_position()-drag_start),Color(0.5,0.5,0.5),false)
		for target in highlighted:
			draw_circle(target.position, 8.0, Color(0.5,0.75,0.5,0.5))
