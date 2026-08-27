extends Node

@export var dialogues : Dictionary[String, DialogueChunk] = {}
@export var dialogue_ui : Control
@onready var game_manager = get_tree().get_first_node_in_group("game_manager")

var current_dialogue : DialogueChunk
var dialogue_progress

signal dialogue_finished(dialogue_name : String)

func start_dialogue(dialogue_name):
	current_dialogue = dialogues[dialogue_name]
	dialogue_progress = 0
	dialogue_ui.visible = true

	var cur_string = current_dialogue.dialogue_lines[0]
	dialogue_ui.set_dialogue(cur_string.line, cur_string.character, cur_string.portrait)
	game_manager.state = game_manager.states.DIALOGUE


func _input(event):
	if (!dialogue_ui.cooldown_timer.is_stopped()): return
	if (!game_manager.state == game_manager.states.DIALOGUE): return
	if (event.is_action_pressed("Interact")):
		if (dialogue_ui.tween and dialogue_ui.tween.is_running()):
			dialogue_ui.tween.kill()
			dialogue_ui.text_box.visible_ratio = 1
		elif (dialogue_progress < current_dialogue.dialogue_lines.size() - 1):
			next_dialogue()
		else:
			dialogue_ui.cooldown_timer.start()
			finish_dialogue()


func next_dialogue():
	dialogue_progress += 1
	var cur_string = current_dialogue.dialogue_lines[dialogue_progress]
	dialogue_ui.set_dialogue(cur_string.line, cur_string.character, cur_string.portrait)


func finish_dialogue():
	dialogue_ui.visible = false
	game_manager.inventory_ui.visible = true
	game_manager.state = game_manager.states.GAME
	dialogue_finished.emit(dialogues.find_key(current_dialogue))
