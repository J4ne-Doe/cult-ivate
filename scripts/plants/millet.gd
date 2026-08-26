extends AbstractPlant

var millet_amt = 0

func on_tick():
	#override this
	var plants = get_tree().get_first_node_in_group("plant_manager")
	var amt = 0

	for plant in plants.plant_tiles.get_children():
		#millets id is 1
		if (plant.id == 1) and (plant.cur_stage == plant.stages):
			amt += 1
	
	millet_amt = amt

	#more earnings per plant, but slower per plant
	var final_value = base_value + (millet_amt - 1) * 0.1
	final_earn_rate = earn_rate * max((millet_amt - 1) * 1.05, 1) * earn_rate_multiplier

	Global.player_money += final_value 
	earn_popup.text = "$" + str(final_value)
