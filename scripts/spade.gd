extends StaticBody2D

@export var shovel_price = 15
@export var icon : Texture2D
@onready var collision = $Area2D
@onready var game_manager = get_tree().get_first_node_in_group("game_manager")

func _physics_process(delta):
	if (collision.has_overlapping_bodies()):
		$Sprite2D.frame = 1

		#buy shovel
		if (Input.is_action_just_pressed("Interact")):
			if (Global.player_money < shovel_price): return
			game_manager.inventory_ui.obtain_shovel(1)
			Global.player_money -= shovel_price
	else:
		$Sprite2D.frame = 0
