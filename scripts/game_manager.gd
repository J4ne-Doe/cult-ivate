extends Node

@export var inventory_ui : Control
@export var plant_details_ui : Control
@export var game_timer_ui : Control

@export var player : CharacterBody2D
@onready var plant_manager = get_tree().get_first_node_in_group("plant_manager")
@export var spade : Node2D
@export var oko : CharacterBody2D

@export var dialogue_manager : Node

var state = states.GAME

enum states {GAME = 0, CUTSCENE = 1, DIALOGUE = 2, DIALOGUE_TYPING = 3}

func _ready():
	dialogue_manager.dialogue_finished.connect(on_dialogue_finished)

func _physics_process(delta):
	manage_plant_details()
	manage_inventory()


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

	if (spade.collision.has_overlapping_bodies()):
		plant_details_ui.visible = true
		plant_details_ui.update_plant("Spade", "Used to return a plant to your inventory, $3 per", spade.icon)
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


func on_dialogue_finished(dialogue_name : String):
	#Main processing for lore / set game
	if (dialogue_name == "introduction"):
		#MMMPHHHHGHHH im so HARD CODING my plants rn (haha get it cuz its hardcoded)
		#2 millets from oko
		inventory_ui.obtain_plant(1, 2)
		game_timer_ui.start_timer(200)

