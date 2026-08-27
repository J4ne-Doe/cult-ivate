extends CharacterBody2D

@export var display_name : String
@onready var game_manager = get_tree().get_first_node_in_group("game_manager")
@onready var sprite = $Sprite2D

var interactable = true

func _ready():
	$AnimationPlayer.play("idle")


func _physics_process(delta):
	if (!interactable): return
	if (game_manager.state == game_manager.states.DIALOGUE): return
	if ($Area2D.has_overlapping_bodies()):
		sprite.frame = 1
		if (Input.is_action_just_pressed("Interact")):
			game_manager.dialogue_manager.start_dialogue("introduction")
			interactable = false
			sprite.frame = 0
	else:
		sprite.frame = 0
