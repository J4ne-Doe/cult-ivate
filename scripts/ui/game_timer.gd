extends Control

@onready var timer = $Timer
@onready var label = $Label

func start_timer(amount):
	timer.wait_time = amount
	timer.start()

func _physics_process(delta):
	if (timer.is_stopped()): return
	label.text = format_time(timer.time_left)


func format_time(seconds : float):
	var minutes = int(seconds) / 60
	var sec = int(seconds) % 60
	return "%02d:%02d" % [minutes, sec]
	
