extends Node2D
class_name AbstractPlant

var rng = RandomNumberGenerator.new()

@onready var earn_popup = get_node("Earn")
@onready var sprite = get_node("Sprite2D") 

@export var id = 1 #SET TO TILESET ID 
@export var stages = 3 #Start at zero
@export var growth_rate : float
@export var earn_rate : float
@export var earn_rate_multiplier : float = 1 #bigger = slower
@export var base_value : float 

@export var display_name : String
@export_multiline var desc : String
@export var icon_texture : Texture2D

@export var has_mutations = false
@export var mutation_chances : PackedFloat32Array #0th is always "no mutation"
@export var mutation_plant_scene_paths : Array[String]

@onready var plant_manager = get_tree().get_first_node_in_group("plant_manager")

var cur_stage = 0
var mutation_plant_instances : Array[Node2D]
var final_earn_rate

func _ready():
	initialization()
	growth_tick()


func initialization():
	final_earn_rate = earn_rate * earn_rate_multiplier
	earn_popup.text = "$" + str(base_value)
	earn_popup.modulate = Color(1, 1, 1, 0)
	sprite.frame = 0

	animation_sway()

	if has_mutations:
		for i in range(mutation_plant_scene_paths.size()):
			mutation_plant_instances.append(load(mutation_plant_scene_paths[i]).instantiate())


func growth_tick():
	await get_tree().create_timer(growth_rate).timeout
	if (cur_stage >= stages):
		tick()

	else:
		cur_stage += 1
		growth_tick()
	sprite.frame = cur_stage


func tick():
	await get_tree().create_timer(final_earn_rate).timeout
	if (has_mutations):
		mutate()
	animation_earn()
	on_tick()

	tick()


func on_growth_tick():
	#override this
	pass


func on_tick():
	#override this
	Global.player_money += base_value
	pass


func mutate():
	var plant_index = rng.rand_weighted(mutation_chances)
	if (plant_index == 0): return #Air
	var plant = mutation_plant_instances[plant_index - 1]
	var cells = plant_manager.plant_tiles.get_surrounding_cells(plant_manager.plant_tiles.local_to_map(position))
	plant_manager.place_plant(plant.id, cells[rng.randi_range(0, 3)])

func animation_earn():
	var tween = get_tree().create_tween().bind_node(self)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(sprite, "scale", Vector2(1.1, 0.9), 0.5)
	tween.parallel().tween_property(earn_popup, "modulate", Color(1, 1, 1, 1), 0.5)
	tween.parallel().tween_property(earn_popup, "offset_transform_position", Vector2(0, -10), 0.5)

	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(earn_popup, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.tween_property(earn_popup, "offset_transform_position", Vector2(0, 0), 0.01)

func animation_sway():
	var tween = get_tree().create_tween().bind_node(self)
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "rotation", deg_to_rad(rng.randf_range(2, 4) * -1), rng.randf_range(2, 2.4))
	tween.tween_property(sprite, "rotation", deg_to_rad(rng.randf_range(2, 4)), rng.randf_range(2, 2.4))

	
