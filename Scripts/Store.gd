extends Popup

signal buy_first_aid_kit
signal buy_pills
signal buy_injection
signal buy_mask

onready var player = $"../Control/Player"

func check_player_money():
	if player.money < 20:
		$Panel/MarginContainer/Container/ShopContainer/Boost/BuyInjectionBtn.disabled = true
	else:
		$Panel/MarginContainer/Container/ShopContainer/Boost/BuyInjectionBtn.disabled = false
		
	if player.money < 30:
		$Panel/MarginContainer/Container/ShopContainer/FirstAidKit/BuyFirstAidBtn.disabled = true
	else:
		$Panel/MarginContainer/Container/ShopContainer/FirstAidKit/BuyFirstAidBtn.disabled = false
	
	if player.money < 60:
		$Panel/MarginContainer/Container/ShopContainer/Pills/BuyPillsBtn.disabled = true
	else:
		$Panel/MarginContainer/Container/ShopContainer/Pills/BuyPillsBtn.disabled = false
		
	if player.money < 80:
		$Panel/MarginContainer/Container/ShopContainer/Mask/BuyMaskBtn.disabled = true
	else:
		$Panel/MarginContainer/Container/ShopContainer/Mask/BuyMaskBtn.disabled = false

func _process(_delta):
	check_player_money()
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().paused = false
		hide()

func _on_BackToMenu_pressed():
	get_tree().paused = false
	if get_tree().change_scene("res://Menus/MainScene.tscn") != OK:
		print("An unexpected error occured while trying to switch to Main scene")

func _on_BuyFirstAidBtn_pressed():
	emit_signal("buy_first_aid_kit")

func _on_BuyPillsBtn_pressed():
	emit_signal("buy_pills")

func _on_BuyInjectionBtn_pressed():
	emit_signal("buy_injection")

func _on_BuyMaskBtn_pressed():
	emit_signal("buy_mask")
