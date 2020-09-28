extends Popup

signal set_player_effect_hud(effect, duration)

onready var player = $"../Player"

enum PRICES {
	INJECTION = 20,
	FIRST_AID_KIT = 30,
	PILLS = 60
	MASK = 80
}

enum EFFECTS_DURATIONS {
	INJECTION = 30,
	MASK = 10
}

var timers = []

func check_player_money():
	if self.player:
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


func close():
	get_tree().paused = false
	self.start_timers()
	self.hide()


func _process(_delta):
	check_player_money()
	if Input.is_key_pressed(KEY_ESCAPE):
		self.close()


func start_timers():
	for timer in self.timers:
		timer.start()
	self.timers = []


func create_timer(duration, callback):
	var player_effect_timer = Timer.new()
	add_child(player_effect_timer)
	player_effect_timer.one_shot = true
	player_effect_timer.wait_time = duration
	player_effect_timer.connect("timeout", self, callback)
	self.timers.append(player_effect_timer)


func _on_BackToGame_pressed():
	self.close()


func _on_BackToMenu_pressed():
	$ConfirmQuitDialog.show()
	$ConfirmQuitDialog.popup_centered()


func _on_ConfirmQuitDialog_confirmed():
	self.close()
	if get_tree().change_scene("res://Scenes/Menus/MainScene.tscn") != OK:
		print("An unexpected error occured while trying to switch to Main scene")


func _on_BuyFirstAidBtn_pressed():
	if self.player.withdraw_money(PRICES.FIRST_AID_KIT):
		self.player.update_health(self.player.health + 10)


func _on_BuyPillsBtn_pressed():
	if self.player.withdraw_money(PRICES.PILLS):
		if randi() % 100 + 1 < 20:
			self.player.update_health(self.player.health - 30)
		else:
			self.player.update_health(self.player.health + 30)


func _on_BuyInjectionBtn_pressed():
	if not self.player.is_effect_active("speed"):
		if self.player.withdraw_money(PRICES.INJECTION):
			self.player.set_effect("speed", true)
			self.player.set_speed(400)
			emit_signal("set_player_effect_hud", "boost", EFFECTS_DURATIONS.INJECTION)
			self.create_timer(EFFECTS_DURATIONS.INJECTION, "_on_SpeedBoostTimer_timeout")


func _on_BuyMaskBtn_pressed():
	if not self.player.is_effect_active("immune"):
		if self.player.withdraw_money(PRICES.MASK):
			self.player.set_effect("immune", true)
			self.player.is_immune = true
			emit_signal("set_player_effect_hud", "immunity", EFFECTS_DURATIONS.MASK)
			self.create_timer(EFFECTS_DURATIONS.MASK, "_on_ImmuneTimer_timeout")


func _on_SpeedBoostTimer_timeout():
	self.player.set_speed(200)
	self.player.set_effect("speed", false)


func _on_ImmuneTimer_timeout():
	self.player.is_immune = false
	self.player.set_effect("immune", false)
