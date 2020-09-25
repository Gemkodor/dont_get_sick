extends Node

func _ready():
	randomize()

func _on_PlayBtn_pressed():
	if Global.pseudo != "Player":
		if get_tree().change_scene("res://Scenes/Levels/Level1.tscn") != OK:
			print("An unexpected error occured while trying to switch to the Game scene")
	else:
		get_tree().change_scene("res://Scenes/Menus/PlayerCreation.tscn")
		
func _on_Options_pressed():
	if get_tree().change_scene("res://Scenes/Menus/Options.tscn") != OK:
		print("An unexpected error occured while trying to switch to the Options scene")
	
func _on_Quit_pressed():
	get_tree().quit()
