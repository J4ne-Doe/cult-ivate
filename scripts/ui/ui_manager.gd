extends Node

@export var inventory_ui : Control
@export var plant_details_ui : Control
@export var dialogue_ui : Control

@export var player : CharacterBody2D
@onready var plant_manager = get_tree().get_first_node_in_group("plant_manager")
@export var spade : Node2D
@export var oko : CharacterBody2D

@export var dialogues : Array[DialogueChunk]


var state = states.GAME

enum states {GAME, CUTSCENE, DIALOGUE}

func _physics_process(delta):
	manage_plant_details()
	manage_inventory()
	
	if (state == states.DIALOGUE):
		tick_dialogue()
	

func manage_plant_details():
	if (state != states.GAME):
		plant_details_ui.visible = false
		return

	var plant_id = plant_manager.plant_tiles.get_cell_alternative_tile(
		plant_manager.plant_tiles.local_to_map(player.global_position)
	)
	
	var tile_source = plant_manager.plant_tiles.tile_set.get_source(1)
	var ins = null
	#if there IS a plant or inventory has plant
	if (plant_id > 0):
		plant_details_ui.visible = true
		ins = tile_source.get_scene_tile_scene(plant_id).instantiate()
		plant_details_ui.update_plant(ins.display_name, ins.desc, ins.icon_texture)
		return

	if (inventory_ui.get_selected_plant_id()):
		plant_details_ui.visible = true
		ins = tile_source.get_scene_tile_scene(inventory_ui.get_selected_plant_id()).instantiate()
		plant_details_ui.update_plant(ins.display_name, ins.desc, ins.icon_texture)
		return

	if (spade.near):
		plant_details_ui.visible = true
		plant_details_ui.update_plant("Spade", "Used to return a plant to your inventory, $10 per", spade.icon)
		return

	plant_details_ui.visible = false


func manage_inventory():
	if (state != states.GAME):
		inventory_ui.visible = false
		return

	if Input.is_action_just_pressed("UILeft"):
		if (inventory_ui.selected_space_id > 0): inventory_ui.selected_space_id -= 1
	if Input.is_action_just_pressed("UIRight"):
		#4 slots inventory, placeholder
		if (inventory_ui.selected_space_id < 4): inventory_ui.selected_space_id += 1


func start_dialogue(id):
	if (state == states.DIALOGUE): return

	#Scuffed fix for not being able to instantly restart dialogue
	if (dialogue_ui.current_dialogue):
		dialogue_ui.current_dialogue = null
		return

	dialogue_ui.visible = true
	state = states.DIALOGUE
	dialogue_ui.set_dialogue(dialogues[id])

func tick_dialogue():
	if (Input.is_action_just_pressed("Interact")):
		if (dialogue_ui.progress < dialogue_ui.current_dialogue.dialogue_lines.size() - 1):
			dialogue_ui.next_dialogue()
		else:
			dialogue_ui.progress = 0
			finish_dialogue(dialogue_ui.current_dialogue)

func finish_dialogue(d):
	dialogue_ui.visible = false
	inventory_ui.visible = true

	#HARDCODING SHIT YEAAAAAAH
	if (d == dialogues[0]):
		inventory_ui.obtain_plant(1, 2)
		#oko gets sent to the shadow realm
		oko.global_position = Vector2(0, 0)
	
	state = states.GAME
