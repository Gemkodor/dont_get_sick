extends Node

func _ready():
	randomize()
	var highscore = Global.read_savegame()
	$VBoxContainer/HighScore/Label.text = "Meilleur score : " + str(highscore)
	
func _on_PlayBtn_pressed():
	if get_tree().change_scene("res://Game/Game.tscn") != OK:
		print("An unexpected error occured while trying to switch to the Game scene")

func _on_Options_pressed():
	if get_tree().change_scene("res://Menus/Options.tscn") != OK:
		print("An unexpected error occured while trying to switch to the Options scene")
	
func _on_Quit_pressed():
	get_tree().quit()
