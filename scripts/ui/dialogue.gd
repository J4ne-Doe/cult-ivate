extends Control

@export var current_dialogue : DialogueString
@export var text_box : RichTextLabel

var dialogue_progress = 0

func _physics_process(delta):
	if (!current_dialogue): return

	#testing using oko intro
	text_box.text = current_dialogue.dialogue[dialogue_progress]

	if (Input.is_action_just_pressed("Interact")):
		if (dialogue_progress < current_dialogue.dialogue.size() - 1):
			dialogue_progress += 1
		else:
			dialogue_progress = 0
			current_dialogue = null
			get_tree().get_first_node_in_group("ui_manager").finish_dialogue()
