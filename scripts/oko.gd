extends CharacterBody2D

@export var display_name : String
@export var interact_distance = 40

@onready var game_manager = get_tree().get_first_node_in_group("game_manager")

var interactable = true

func _ready():
	$AnimationPlayer.play("idle")


func _physics_process(delta):
	if (game_manager.state == game_manager.states.DIALOGUE): return
	if (!interactable): return

	if (global_position.distance_to(get_tree().get_first_node_in_group("player").global_position) < interact_distance):
		$Sprite2D.frame = 1
		if (Input.is_action_just_pressed("Interact")):
			game_manager.dialogue_manager.start_dialogue("introduction")
	else:
		$Sprite2D.frame = 0
