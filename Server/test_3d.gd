extends Node3D

const PickUp = preload("res://Inventory/Item/Items/Pickup.tscn")
@onready var character_body_3d = $CharacterBody3D
@onready var inventory_interface = $CanvasLayer/InventoryInterface

# Called when the node enters the scene tree for the first time.
func _ready():
	character_body_3d.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(character_body_3d.inventory_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)


func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()


func _on_inventory_interface_drop_slot_data(slot_data):
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = character_body_3d.get_drop_position()
	add_child(pick_up)
