extends Control

signal drop_slot_data(slot_data : SlotData)

var grabbed_slot_data: SlotData
var external_inventory_owner

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var external_inventory = $ExternalInventory

func _physics_process(delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)

func set_player_inventory_data(inventory_data : InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	
	if inventory_data:
		inventory_data.inventory_interact.connect(on_inventory_interact)
		external_inventory.set_inventory_data(inventory_data)
	
		external_inventory.show()
	else:
		print("null inventory data for %s" % external_inventory_owner)
	
func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		
		if inventory_data:
			inventory_data.inventory_interact.disconnect(on_inventory_interact)
			external_inventory.clear_inventory_data(inventory_data)
		
			external_inventory.hide()
		else:
			print("null inventory data for %s" % external_inventory_owner)
		

func on_inventory_interact(inventory_data: InventoryData, index: int, event: InputEvent) -> void:
	#figure out how to fast transfer between inventory items
	match [grabbed_slot_data, event.button_index]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
			grabbed_slot_data = throw_slot_data_to_other_inventory(grabbed_slot_data,inventory_data)
		[null, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.split_slot_data(index)
			grabbed_slot_data = throw_slot_data_to_other_inventory(grabbed_slot_data,inventory_data)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data,index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_split_slot_data(grabbed_slot_data,index)
	
	update_grabbed_slot()
	
func throw_slot_data_to_other_inventory(slot_data, inventory_data):
	if slot_data:
		if Input.is_key_pressed(KEY_SHIFT):
			var success : bool = false
			if external_inventory_owner and external_inventory_owner.inventory_data != inventory_data:
				success = external_inventory_owner.inventory_data.pick_up_slot_data(slot_data)
			else:
				success = player_inventory.inventory_data.pick_up_slot_data(slot_data)
			if success:
				slot_data = null
	return slot_data

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()


func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.is_pressed() \
			and grabbed_slot_data:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drop_slot_data.emit(grabbed_slot_data)
				grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				if grabbed_slot_data.quantity == 1:
					drop_slot_data.emit(grabbed_slot_data)
					grabbed_slot_data = null
				else:
					drop_slot_data.emit(grabbed_slot_data.split())
		update_grabbed_slot()

func _on_visibility_changed():
	if not visible and grabbed_slot_data:
		drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
