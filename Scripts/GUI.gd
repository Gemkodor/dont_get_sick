extends MarginContainer

onready var health_number = $Bars/VBoxContainer/LifeBar/Counters/Counter/Background/Number
onready var health_bar = $Bars/VBoxContainer/LifeBar/Counters/Gauge
onready var money_number = $Bars/Counters/EmeraldCounter/Counter/Background/Number
onready var tween = $Tween

var boost_texture = preload("res://assets/icons/fast.png")
var mask_texture = preload("res://assets/icons/mask.png")

var animated_health = 100

func _process(_delta):
	var round_value = round(animated_health)
	health_number.text = str(round_value)
	health_bar.value = round_value
	
func _on_Player_health_changed(new_value):
	update_health(new_value)

func update_health(new_health):
	tween.interpolate_property(self, "animated_health", animated_health, new_health, 0.6)
	if not tween.is_active():
		tween.start()

func _on_Player_money_changed(new_money):
	money_number.text = str(new_money)

func _on_Timer_timeout():
	if not get_tree().paused:
		Global.score += 1
	$Bars/HBoxContainer/TimePlayedLabel.text = "Score : " + str(Global.score)

func _on_Player_set_player_effect_hud(effect, deactivate):
	match effect:
		"boost":
			if deactivate:
				$"../PlayerEffects".remove_child($"../PlayerEffects/BoostTexture")
			else:
				var texture_rect = TextureRect.new()
				texture_rect.texture = boost_texture
				texture_rect.name = "BoostTexture"
				$"../PlayerEffects".add_child(texture_rect)
		"immunity":
			if deactivate:
				$"../PlayerEffects".remove_child($"../PlayerEffects/ImmunityTexture")
			else:
				var texture_rect = TextureRect.new()
				texture_rect.texture = mask_texture
				texture_rect.name = "ImmunityTexture"
				$"../PlayerEffects".add_child(texture_rect)
