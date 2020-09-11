extends MarginContainer

func _ready():
	Global.save()
	$VBoxContainer/HBoxContainer/Label.text = str("Perdu ! Vous avez fait un score de : " + str(Global.score))

func _on_Button_pressed():
	print("back to game")
	if get_tree().change_scene("res://Game/Game.tscn") != OK:
		print("An unexpected error occured while trying to switch to Game scene")

func _on_BackToMenu_pressed():
	if get_tree().change_scene("res://Menus/MainScene.tscn") != OK:
		print("An unexpected error occured while trying to switch to Main scene")
