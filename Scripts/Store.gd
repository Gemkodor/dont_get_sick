extends Popup

signal set_player_effect_hud(effect, duration)

onready var player = $"../Player"
onready var resume_game_label = $"../HUD/ResumeGameLbl"
onready var resume_game_timer = $"../HUD/ResumeGameTimer"

const DELAY_GAME_RESUME = 2

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
var counter_resume_game = DELAY_GAME_RESUME


func _ready():
	self.resume_game_timer.connect("timeout", self, "_resume_game_timer_timeout")


func _process(_delta):
	self.check_player_money()


func _input(event):
	if event.is_action_pressed("close") and self.visible:
		self.hide()
		self.start_delay_on_resume()


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


func create_timer(duration, callback):
	var new_timer = Timer.new()
	new_timer.one_shot = true
	new_timer.wait_time = duration
	new_timer.connect("timeout", self, callback)
	add_child(new_timer)
	return new_timer


func start_delay_on_resume():
	if Global.display_resume_game_timer and Global.score >= Global.resume_game_timer_duration:
		var timer = self.create_timer(self.DELAY_GAME_RESUME, "resume_game")
		timer.start()
		
		self.counter_resume_game = self.DELAY_GAME_RESUME
		self.resume_game_label.text = str(self.counter_resume_game)
		self.resume_game_label.show()
		self.resume_game_timer.start()
	else:
		self.resume_game()


func resume_game():
	get_tree().paused = false
	self.start_timers()


func start_timers():
	for timer in self.timers:
		timer.start()
	self.timers = []


func _resume_game_timer_timeout():
	self.counter_resume_game -= 1
	if self.counter_resume_game <= 0:
		self.resume_game_label.hide()
		self.resume_game_timer.stop()
	else:
		self.resume_game_label.text = str(self.counter_resume_game)


func _on_SpeedBoostTimer_timeout():
	self.player.set_speed(200)
	self.player.set_effect("speed", false)


func _on_ImmuneTimer_timeout():
	self.player.is_immune = false
	self.player.set_effect("immune", false)


func _on_BackToGame_pressed():
	self.hide()
	self.start_delay_on_resume()


func _on_BackToMenu_pressed():
	$ConfirmQuitDialog.show()
	$ConfirmQuitDialog.popup_centered()


func _on_ConfirmQuitDialog_confirmed():
	self.hide()
	get_tree().paused = false
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
			var player_effect_timer = self.create_timer(EFFECTS_DURATIONS.INJECTION, "_on_SpeedBoostTimer_timeout")
			self.timers.append(player_effect_timer)


func _on_BuyMaskBtn_pressed():
	if not self.player.is_effect_active("immune"):
		if self.player.withdraw_money(PRICES.MASK):
			self.player.set_effect("immune", true)
			self.player.is_immune = true
			emit_signal("set_player_effect_hud", "immunity", EFFECTS_DURATIONS.MASK)
			var player_effect_timer = self.create_timer(EFFECTS_DURATIONS.MASK, "_on_ImmuneTimer_timeout")
			self.timers.append(player_effect_timer)
