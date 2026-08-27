extends Control

@export var current_dialogue : DialogueChunk
@export var text_box : RichTextLabel
@export var char_name : Label

@export var texture : TextureRect
@onready var cooldown_timer = $Cooldown

var tween

func set_dialogue(line, character, portrait):
	text_box.text = line
	char_name.text = character
	texture.texture = portrait

	if tween:
		tween.kill()

	text_box.visible_ratio = 0
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(text_box, "visible_ratio", 1, 2)
