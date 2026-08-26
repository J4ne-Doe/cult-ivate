extends Control

@export var inventory : Array[Panel]
@export var selected_space_id : int = 0

@onready var plant_manager = get_tree().get_first_node_in_group("plant_manager") 

@export var shovel : Label

func _process(delta):
	$Selector.global_position = inventory[selected_space_id].global_position


func obtain_plant(plant_id, amount):
	#loop through slots, if empty or same plant add plant else move on
	var plant_scene = get_scene_from_plant_id(plant_id)
	for item in inventory:
		if (item.current_plant == plant_scene):
			item.add_plant(plant_scene, amount)
			return 1
	
	#loop again, if there is no matching plants
	for item in inventory:
		if (!item.current_plant):
			item.add_plant(plant_scene, amount)
			return 1

	return 0


func has_plant(plant_id):
	var plant_scene = get_scene_from_plant_id(plant_id) 
	for item in inventory:
		if (item.current_plant == plant_scene):
			return item 
	return false


func remove_plant(plant_id, amt):
	var inv_space = has_plant(plant_id)
	inv_space.rmv_plant(amt)


func obtain_shovel(amt):
	Global.shovel_amt += amt
	shovel.text = "Shovel amount: " + str(Global.shovel_amt)

func remove_shovel(amt):
	obtain_shovel(amt * -1)

func get_scene_from_plant_id(id):
	return plant_manager.plant_tiles.tile_set.get_source(1).get_scene_tile_scene(id)

func get_selected_plant_id():
	var plant_scene = inventory[selected_space_id].current_plant

	if (!plant_scene): return
	var ins = plant_scene.instantiate()
	return ins.id
	
