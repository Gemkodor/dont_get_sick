extends Control


func _ready():
	pass # Replace with function body.


func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE) and get_tree().change_scene("res://Scenes/Menus/MainScene.tscn") != OK:
		print("An unexpected error occured while trying to switch to Main scene")


func _on_CheckBox_toggled(button_pressed):
	Global.music_activated = button_pressed


func _on_CheckBox_ready():
	$MarginContainer/VBoxContainer/HBoxContainer/MusicSetting.pressed = Global.music_activated


func _on_BackBtn_pressed():
	self.call_deferred("free")
	get_tree().change_scene("res://Scenes/Menus/MainScene.tscn")
