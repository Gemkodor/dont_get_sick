extends Node


func _ready():
	randomize()


func _on_PlayBtn_pressed():
	self.call_deferred("free")
	get_tree().change_scene("res://Scenes/Menus/PlayerCreation.tscn")


func _on_Options_pressed():
	self.call_deferred("free")
	if get_tree().change_scene("res://Scenes/Menus/Options.tscn") != OK:
		print("An unexpected error occured while trying to switch to the Options scene")


func _on_Quit_pressed():
	get_tree().quit()
