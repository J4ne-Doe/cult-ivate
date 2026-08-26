extends AbstractPlant

func _physics_process(delta):
	var cells = plant_manager.plant_tiles.get_surrounding_cells(plant_manager.plant_tiles.local_to_map(position))
	for cell in cells:
		var plant = plant_manager.get_plant_from_pos(cell)
		if (plant):
			plant.earn_rate_multiplier = 2 
