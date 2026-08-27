extends Node

@export var dialogues : Dictionary[String, DialogueChunk] = {}
@export var dialogue_ui : Control
@onready var game_manager = get_tree().get_first_node_in_group("game_manager")

func _physics_process(delta):
	if (game_manager.state == game_manager.states.DIALOGUE):
		tick_dialogue()

func start_dialogue(dialogue):
	#Scuffed fix for not being able to instantly restart dialogue
	if (dialogue_ui.current_dialogue):
		dialogue_ui.current_dialogue = null
		return

	dialogue_ui.visible = true
	game_manager.state = game_manager.states.DIALOGUE
	dialogue_ui.set_dialogue(dialogues[dialogue])

func tick_dialogue():
	if (Input.is_action_just_pressed("Interact")):
		if (dialogue_ui.progress < dialogue_ui.current_dialogue.dialogue_lines.size() - 1):
			dialogue_ui.next_dialogue()
		else:
			dialogue_ui.progress = 0
			finish_dialogue(dialogue_ui.current_dialogue)

func finish_dialogue(d):
	dialogue_ui.visible = false
	game_manager.inventory_ui.visible = true
	game_manager.state = game_manager.states.GAME
