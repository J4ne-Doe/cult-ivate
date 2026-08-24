extends Panel

@export var current_plant : PackedScene
@export var plant_amount : int

func add_plant(plant : PackedScene, amt : int):
	current_plant = plant
	plant_amount += amt

	var ins = plant.instantiate()

	$Sprite2D.texture = ins.icon_texture
	$Label.text = "x" + str(plant_amount)

func rmv_plant(amt : int):
	if (plant_amount < amt) : return
	plant_amount -= amt

	if (plant_amount == 0):
		current_plant = null
		$Sprite2D.texture = null
		$Label.text = ""
	else:
		$Label.text = "x" + str(plant_amount)
