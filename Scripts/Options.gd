extends Control


onready var music_checkbox = $MarginContainer/VBoxContainer/HBoxContainer/MusicSetting
onready var countdown_checkbox = $MarginContainer/VBoxContainer/HBoxContainer3/CountdownSetting
onready var countdown_duration = $MarginContainer/VBoxContainer/HBoxContainer4/CountdownDuration


func _ready():
	self.music_checkbox.pressed = Global.music_activated
	self.countdown_checkbox.pressed = Global.display_resume_game_timer
	self.countdown_duration.value = Global.resume_game_timer_duration


func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE) and get_tree().change_scene("res://Scenes/Menus/MainScene.tscn") != OK:
		print("An unexpected error occured while trying to switch to Main scene")


func _on_BackBtn_pressed():
	self.call_deferred("free")
	get_tree().change_scene("res://Scenes/Menus/MainScene.tscn")


func _on_MusicSetting_toggled(button_pressed):
	Global.music_activated = button_pressed


func _on_CountdownSetting_toggled(button_pressed):
	Global.display_resume_game_timer = button_pressed


func _on_CountdownDuration_value_changed(value):
	Global.resume_game_timer_duration = value
