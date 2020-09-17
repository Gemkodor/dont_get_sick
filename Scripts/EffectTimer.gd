extends Control

onready var icon = $HBoxContainer/Icon
onready var counter_label = $HBoxContainer/Counter
onready var timer = $HBoxContainer/UpdateCountTimer

onready var boost_texture : Texture = preload("res://assets/icons/fast.png")
onready var mask_texture : Texture = preload("res://assets/icons/mask.png")

var counter

func display_effect(effect, duration):
	match effect:
		"boost":
			self.name = "BoostEffect"
			self.icon.texture = boost_texture
			self.icon.name = "BoostTexture"
			self.start_timer(duration)
		"immunity":
			self.name = "ImmunityEffect"
			self.icon.texture = mask_texture
			self.icon.name = "ImmunityTexture"
			self.start_timer(duration)

func start_timer(duration):
	counter = duration
	counter_label.text = str(counter)
	timer.start()

func _on_Timer_timeout():
	counter -= 1
	counter_label.text = str(counter)
	
	if counter == 0:
		self.queue_free()
