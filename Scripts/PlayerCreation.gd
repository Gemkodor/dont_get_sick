extends Control


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://Scenes/Menus/MainScene.tscn")
		if event.pressed and event.scancode == KEY_ENTER:
			self.load_game()


func load_game():
	var pseudo = $HBoxContainer/PseudoInput.text
	if pseudo != "":
		Global.pseudo = $HBoxContainer/PseudoInput.text
		get_tree().change_scene("res://Scenes/Game.tscn")
		

func _on_PlayBtn_pressed():
	self.load_game()
