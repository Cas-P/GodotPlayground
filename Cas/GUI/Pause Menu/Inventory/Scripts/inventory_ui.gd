class_name InventoryUI extends Control


const INVENTORY_SLOT = preload("res://Cas/GUI/Pause Menu/Inventory/inventory_slot.tscn")

@export var data: InventoryData


func _ready() -> void:
	PauseMenu.shown.connect(update_inventory)
	PauseMenu.hidden.connect(clear_inventory)
	clear_inventory()
	data.changed.connect(on_inventory_changed)
	pass


func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()

func update_inventory() -> void:
	if data.slots.size() <= 0:
		return
	
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
	
	get_child(0).grab_focus()

func on_inventory_changed() -> void:
	
	clear_inventory()
	update_inventory()
