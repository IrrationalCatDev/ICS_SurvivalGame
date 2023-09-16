extends Resource
class_name SlotData

const MAX_STACK_SIZE: int = 99

@export var item_data : ItemData
@export_range(1, MAX_STACK_SIZE) var quantity : int = 1: set = set_quantity

func split() -> SlotData:
	if quantity == 1:
		return null
	var split_data = duplicate()
	var newQ = quantity / 2
	split_data.quantity = newQ
	quantity -= newQ
	return split_data

func split_amount(count: int) -> SlotData:
	var split_data = duplicate()
	if count > quantity:
		return null
	split_data.quantity = count
	quantity -= count
	return split_data
	

func can_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data and item_data.stackable \
			and quantity != MAX_STACK_SIZE

func partial_merge_with(other_slot_data: SlotData) -> SlotData:
	var new_total = other_slot_data.quantity + quantity
	var new_slot_data : SlotData
	quantity = new_total
	if new_total > MAX_STACK_SIZE:
		new_slot_data = SlotData.new()
		new_slot_data.item_data = other_slot_data.item_data
		new_slot_data.quantity = new_total - MAX_STACK_SIZE
	return new_slot_data

func set_quantity(value : int) -> void:
	quantity = clamp(value,1,MAX_STACK_SIZE)
	if quantity > 1 and not item_data.stackable:
		quantity = 1
		push_error("$s not stackable" % item_data.name)
