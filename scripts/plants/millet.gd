extends AbstractPlant

var millet_amt = 0

func on_tick():
	#override this
	var plants_layer = get_tree().get_first_node_in_group("plant_tile_layer")
	var amt = 0

	for plant in plants_layer.get_children():
		#millets id is 1
		if (plant.id == 1) and (plant.cur_stage == plant.stages):
			amt += 1
	
	millet_amt = amt

	$AnimationPlayer.play("bounce")
	
	#more earnings per plant, but slower per plant
	# 5 is base earn rate, too lazy to make a base earn rate var
	var final_value = base_value + (millet_amt - 1) * 0.1
	earn_rate = 1 * max((millet_amt - 1) * 1.05, 1)

	Global.player_money += final_value 
	earn_popup.text = "$" + str(final_value)
