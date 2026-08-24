extends CharacterBody2D

var rng = RandomNumberGenerator.new()

@export var dialogues : Array[DialogueString]

func _physics_process(delta):
	$Sprite2D.position.x = rng.randf_range(-2, 2)
	$Sprite2D.position.y = rng.randf_range(-2, 2)

	if (Input.is_action_just_pressed("Three")):
		get_tree().get_first_node_in_group("ui_manager").start_dialogue(dialogues[0])
