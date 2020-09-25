extends Control


func _on_PlayBtn_pressed():
	Global.pseudo = $HBoxContainer/PseudoInput.text
	get_tree().change_scene("res://Scenes/Game.tscn")

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://Scenes/Menus/MainScene.tscn")
