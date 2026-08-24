extends Node

@export var inventory : Control
@export var plant_details : Control
@export var dialogue : Control

@export var player : CharacterBody2D
@onready var plant_manager = get_tree().get_first_node_in_group("plant_manager")

var state = states.GAME

enum states {GAME, CUTSCENE, DIALOGUE}

func _physics_process(delta):
	manage_plant_details()
	manage_inventory()
	
	#PLACEHOLLLLDERRRR
	if (Input.is_action_just_pressed("Three")):
		start_dialogue(null)


func manage_plant_details():
	if (state != states.GAME):
		plant_details.visible = false
		return

	var plant_id = plant_manager.plant_tiles.get_cell_alternative_tile(
		plant_manager.plant_tiles.local_to_map(player.global_position)
	)
	
	var tile_source = plant_manager.plant_tiles.tile_set.get_source(1)
	var ins = null
	#if there IS a plant or inventory has plant
	if (plant_id > 0):
		plant_details.visible = true
		ins = tile_source.get_scene_tile_scene(plant_id).instantiate()
		plant_details.update_plant(ins.display_name, ins.desc, ins.icon_texture)
		return

	if (inventory.get_selected_plant_id()):
		plant_details.visible = true
		ins = tile_source.get_scene_tile_scene(inventory.get_selected_plant_id()).instantiate()
		plant_details.update_plant(ins.display_name, ins.desc, ins.icon_texture)
		return
	
	plant_details.visible = false


func manage_inventory():
	if (state != states.GAME):
		inventory.visible = false
		return

	if Input.is_action_just_pressed("UILeft"):
		if (inventory.selected_space_id > 0): inventory.selected_space_id -= 1
	if Input.is_action_just_pressed("UIRight"):
		#4 slots inventory, placeholder
		if (inventory.selected_space_id < 4): inventory.selected_space_id += 1



func start_dialogue(d_text : DialogueString):
	dialogue.visible = true
	state = states.DIALOGUE
	dialogue.current_dialogue = d_text

func finish_dialogue():
	dialogue.visible = false
	state = states.GAME
