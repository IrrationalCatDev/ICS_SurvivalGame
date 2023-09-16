extends Node3D

@onready var character_body_3d = $CharacterBody3D
@onready var inventory_interface = $CanvasLayer/InventoryInterface

# Called when the node enters the scene tree for the first time.
func _ready():
	character_body_3d.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(character_body_3d.inventory_data)


func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
