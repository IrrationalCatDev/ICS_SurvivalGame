extends PanelContainer

const Slot = preload("res://Inventory/InventorySlot.tscn")
@onready var item_grid : GridContainer = $VBoxContainer/MarginContainer/ItemGrid

var inventory_data : InventoryData

func set_inventory_data(_inventory_data : InventoryData) -> void:
	inventory_data = _inventory_data
	_inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(_inventory_data)

func clear_inventory_data(_inventory_data : InventoryData) -> void:
	inventory_data = null
	_inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(_inventory_data : InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in _inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(_inventory_data.on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)
