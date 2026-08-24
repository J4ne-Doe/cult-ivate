extends StaticBody2D

@export var money_label : Label

func _process(delta):
	money_label.text = str(Global.player_money).pad_decimals(2)
