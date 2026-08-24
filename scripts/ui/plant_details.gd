extends Control

@export var ui_name : Label
@export var ui_desc : RichTextLabel
@export var ui_icon : TextureRect 

func update_plant(name, desc, icon):
	ui_name.text = name
	ui_desc.text = desc
	ui_icon.texture = icon
