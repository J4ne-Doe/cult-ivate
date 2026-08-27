extends Control

@export var label : Label
@export var timer : Timer

func start_timer(sec):
	timer.start(sec)

func _physics_process(delta):
	if (timer.is_stopped()): return
	label.text = str(timer.time_left).pad_decimals(2)
