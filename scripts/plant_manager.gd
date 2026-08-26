extends Node

@export var plant_tiles : TileMapLayer
@export var floor_tiles : TileMapLayer

@export var inventory : Control


#used for player due to inventory management
func player_place_plant(plant_id, pos):
	if (!inventory.has_plant(plant_id)): return

	if (place_plant(plant_id, plant_tiles.local_to_map(pos))):
		inventory.remove_plant(plant_id, 1)

func player_remove_plant(pos):
	if (Global.shovel_amt < 1): return
	var tile_pos = plant_tiles.local_to_map(pos)

	if (tile_has_plant(tile_pos)):
		var plant_id = plant_tiles.get_cell_alternative_tile(tile_pos)
		inventory.obtain_plant(plant_id, 1)
		plant_tiles.set_cell(tile_pos, -1)
		inventory.remove_shovel(1)


func place_plant(plant_id, plant_cell_pos):
	if (!floor_tiles.get_cell_tile_data(plant_cell_pos).get_custom_data("plantable")): return
	if (tile_has_plant(plant_cell_pos)): return

	#Atlas coords is always zero due to scene collection tile map
	#Alternative tile is used for id, starting at 1
	plant_tiles.set_cell(plant_cell_pos, 1, Vector2.ZERO, plant_id)
	print("planted at" + str(plant_cell_pos))

	return true


func tile_has_plant(cell_pos):
	return plant_tiles.get_cell_source_id(cell_pos) != -1

func get_plant_from_pos(cell_pos):
	for child in plant_tiles.get_children():
		if (cell_pos == plant_tiles.local_to_map(child.position)):
			return child
	
	return false
