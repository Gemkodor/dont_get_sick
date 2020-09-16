extends Control

onready var timer = $UpdateCountTimer
onready var counter_label = $Counter

var counter

func start_timer(duration):
	counter = duration
	counter_label.text = str(counter)
	timer.start()

func _on_Timer_timeout():
	counter -= 1
	counter_label.text = str(counter)
	
	if counter == 0:
		self.queue_free()
