extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, event: InputEvent)

@export var slot_datas : Array[SlotData]

func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func split_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	if slot_data:
		var new_data = slot_data.split()
		inventory_updated.emit(self)
		return new_data
	return null
	
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	var returned_slot_data: SlotData
	if slot_data and slot_data.can_merge_with(grabbed_slot_data):
		returned_slot_data = slot_data.partial_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		returned_slot_data = slot_data
	
	inventory_updated.emit(self)
	return returned_slot_data

func drop_split_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	var returned_slot_data: SlotData
	if slot_data and slot_data.can_merge_with(grabbed_slot_data):
		var new_data = grabbed_slot_data.split()
		if not new_data:
			new_data = grabbed_slot_data
			grabbed_slot_data = null
		var new_merged_data = slot_data.partial_merge_with(new_data)
		if new_merged_data != null:
			var excess = grabbed_slot_data.partial_merge_with(new_merged_data)
			if excess != null:
				push_error("too much stuff!")
		returned_slot_data = grabbed_slot_data
	else:
		slot_datas[index] = grabbed_slot_data
		returned_slot_data = slot_data
	inventory_updated.emit(self)
	return returned_slot_data

func on_slot_clicked(index: int, event: InputEvent) -> void:
	inventory_interact.emit(self, index, event)
