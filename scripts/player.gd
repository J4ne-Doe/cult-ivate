extends CharacterBody2D


@export var spd = 100
@export var plant_manager : Node
@export var inventory : Control

func _physics_process(delta):

	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * spd 

	move_and_slide()
	manage_animation(input_direction)

	#placeholder
	if (Input.is_action_just_pressed("One")): inventory.obtain_plant(1, 1)
	if (Input.is_action_just_pressed("Two")): inventory.obtain_plant(2, 1)
	if (Input.is_action_just_pressed("Interact")):
		var cur_plant = inventory.get_selected_plant_id()
		if (cur_plant):
			plant_manager.place_plant(cur_plant, global_position)

func manage_animation(direction):
	match (direction):
		Vector2(0, 1):
			$Sprite.frame = 0
		Vector2(1, 0):
			$Sprite.frame = 1
		Vector2(0, -1):
			$Sprite.frame = 2
		Vector2(-1, 0):
			$Sprite.frame = 3
		Vector2(0, 0):
			$AnimationPlayer.current_animation = "idle"
	
	if (direction != Vector2.ZERO):
		if ($Sprite.frame == 0) or ($Sprite.frame == 2):
			$AnimationPlayer.current_animation = "walking"
		elif ($Sprite.frame == 1 or $Sprite.frame == 3):
			$AnimationPlayer.current_animation = "walking_sideways"
