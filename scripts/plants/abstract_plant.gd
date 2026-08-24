extends Node2D
class_name AbstractPlant

@export var earn_popup : Label

@export var id = 1 #SET TO TILESET ID 
@export var stages = 3 #Start at zero
@export var growth_rate : float
@export var earn_rate : float 
@export var base_value : float 

@export var display_name : String
@export_multiline var desc : String

@export var icon_texture : Texture2D

var cur_stage = 0


func _ready():
	$AnimationPlayer.play("idle")
	$AnimationPlayer.animation_finished.connect(on_anim_done)
	growth_tick()

func growth_tick():
	await get_tree().create_timer(growth_rate).timeout
	if (cur_stage >= stages):
		tick()

	else:
		cur_stage += 1
		growth_tick()
	$Sprite2D.frame_coords.x = cur_stage

func tick():
	await get_tree().create_timer(earn_rate).timeout
	on_tick()
	tick()

func on_growth_tick():
	#override this
	pass

func on_tick():
	#override this
	$AnimationPlayer.play("bounce")
	Global.player_money += base_value
	pass

func on_anim_done(anim_name):
	$AnimationPlayer.play("idle")
	
