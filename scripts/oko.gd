extends CharacterBody2D

@export var display_name : String
@export var interact_distance = 40

@onready var ui_manager = get_tree().get_first_node_in_group("ui_manager")

func _ready():
	$AnimationPlayer.play("idle")


func _physics_process(delta):
	if (ui_manager.state == ui_manager.states.DIALOGUE): return

	if (global_position.distance_to(get_tree().get_first_node_in_group("player").global_position) < interact_distance):
		$Sprite2D.frame = 1
		if (Input.is_action_just_pressed("Interact")):
			ui_manager.start_dialogue(0)
	else:
		$Sprite2D.frame = 0

