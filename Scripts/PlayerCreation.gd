extends Control


func _ready():
	if Global.selected_player == "Betty":
		$BettyBtn.pressed = true
		

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://Scenes/Menus/MainScene.tscn")
		if event.pressed and event.scancode == KEY_ENTER:
			self.load_game()


func load_game():
	var pseudo = $PseudoInput.text
	if pseudo != "":
		Global.pseudo = $PseudoInput.text
		get_tree().change_scene("res://Scenes/Game.tscn")
		

func _on_PlayBtn_pressed():
	self.load_game()


func _on_BettyBtn_pressed():
	$GeorgeBtn.pressed = false
	Global.selected_player = "Betty"


func _on_GeorgeBtn_pressed():
	$BettyBtn.pressed = false
	Global.selected_player = "George"
