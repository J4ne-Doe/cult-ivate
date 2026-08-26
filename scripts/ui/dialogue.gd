extends Control

@export var current_dialogue : DialogueChunk
@export var text_box : RichTextLabel
@export var char_name : Label

@export var texture : TextureRect

var progress = 0
var tween

func set_dialogue(dialogue_chunk : DialogueChunk):
	current_dialogue = dialogue_chunk
	var cur_dial = current_dialogue.dialogue_lines[progress]
	text_box.text = cur_dial.line
	char_name.text = cur_dial.character
	texture.texture = cur_dial.portrait

	text_box.visible_ratio = 0
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(text_box, "visible_ratio", 1, 2)

func next_dialogue():
	progress += 1
	var cur_dial = current_dialogue.dialogue_lines[progress]
	text_box.text = cur_dial.line
	char_name.text = cur_dial.character
	texture.texture = cur_dial.portrait

	if tween:
		tween.kill()

	text_box.visible_ratio = 0
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(text_box, "visible_ratio", 1, 2)
