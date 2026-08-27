extends CharacterBody2D


@export var spd = 100
@export var plant_manager : Node
@export var inventory : Control

@export var display_name = "Jane"

@onready var game_manager = get_tree().get_first_node_in_group("game_manager")

func _ready():
	$AnimationPlayer.play("bobbing")

func _physics_process(delta):

	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * spd 

	manage_animation(input_direction)

	if (game_manager.state == game_manager.states.DIALOGUE):return
	move_and_slide()

	#placeholder
	if (Input.is_action_just_pressed("One")): inventory.obtain_plant(1, 1)
	if (Input.is_action_just_pressed("Two")): inventory.obtain_plant(2, 1)
	
	if (Input.is_action_pressed("Shift") and Input.is_action_just_pressed("Interact")):
		plant_manager.player_remove_plant(global_position)
	elif (Input.is_action_just_pressed("Interact")):
		var cur_plant = inventory.get_selected_plant_id()
		if (cur_plant):
			plant_manager.player_place_plant(cur_plant, global_position)

func manage_animation(direction):
	if (game_manager.state == game_manager.states.DIALOGUE):
		$Sprite.animation = "idle"
		$Sprite.frame = 2
		return

	#YandereDev cosplay moment
	if (direction.y > 0.5):
		$Sprite.play("walking_down")
	elif (direction.y < -0.5):
		$Sprite.play("walking_up")
	elif (direction.x > 0.5):
		$Sprite.play("walking_right")
	elif(direction.x < -0.5):
		$Sprite.play("walking_left")
	else:
		$Sprite.play("idle")
