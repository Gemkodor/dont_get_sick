extends MarginContainer

onready var player : Node = $"../../Player"
onready var health_number : Label = $Bars/VBoxContainer/LifeBar/Counters/Counter/Background/Number
onready var health_bar : TextureProgress = $Bars/VBoxContainer/LifeBar/Counters/Gauge
onready var money_number : Label = $Bars/Counters/EmeraldCounter/Counter/Background/Number
onready var player_effects_box : Node = $"../PlayerEffects"
onready var tween : Tween = $Tween
onready var player_effect_scene : PackedScene = preload("res://Scenes/HUD/PlayerEffect.tscn")

var animated_health : int = 100

func _ready():
	money_number.text = str(self.player.money)

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

func _on_StorePopup_set_player_effect_hud(effect, duration):
	var player_effect = player_effect_scene.instance()
	player_effects_box.add_child(player_effect)
			
	match effect:
		"boost":
			player_effect.display_effect("boost", duration)
		"immunity":
			player_effect.display_effect("immunity", duration)
