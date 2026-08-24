extends Node

@export var plant_tiles : TileMapLayer
@export var floor_tiles : TileMapLayer

@export var inventory : Control

func place_plant(plant_id, pos):
	var plant_pos = plant_tiles.local_to_map(pos)
	var floor_pos = floor_tiles.local_to_map(pos)

	#if cant plant return
	if (!floor_tiles.get_cell_tile_data(floor_pos).get_custom_data("plantable")): return
	#if no plant in inventory return
	if (!inventory.has_plant(plant_id)): return

	#Atlas coords is always zero due to scene collection tile map
	#Alternative tile is used for id, starting at 1
	plant_tiles.set_cell(plant_pos, 1, Vector2.ZERO, plant_id)
	inventory.remove_plant(plant_id, 1)
