extends StaticBody2D

@export var interact_distance = 40
@export var shovel_price = 15
@export var icon : Texture2D

@onready var game_manager = get_tree().get_first_node_in_group("game_manager")

var near = false

func _physics_process(delta):
	if (game_manager.state == game_manager.states.DIALOGUE): return

	if (global_position.distance_to(get_tree().get_first_node_in_group("player").global_position) < interact_distance):
		near = true
		$Sprite2D.frame = 1
		if (Input.is_action_just_pressed("Interact")):
			if (Global.player_money < shovel_price): return
			game_manager.inventory_ui.obtain_shovel(1)
			Global.player_money -= shovel_price
	else:
		$Sprite2D.frame = 0
		near = false
