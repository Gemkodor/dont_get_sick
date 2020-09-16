extends KinematicBody2D

# Variables
export var speed = 200
export var is_immune = false
export var is_infected = false
export var max_health = 100

var health = max_health
var money = 0
var screen_size

# Signals
signal health_changed
signal money_changed
signal coin_collected
signal set_player_effect_hud

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.animation = "right"
		velocity.x += 1
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite.animation = "left"
		velocity.x -= 1
	elif Input.is_action_pressed("ui_up"):
		$AnimatedSprite.animation = "up"
		velocity.y -= 1
	elif Input.is_action_pressed("ui_down"):
		$AnimatedSprite.animation = "down"
		velocity.y += 1
		
	if velocity.length() > 0:
		$AnimatedSprite.play()
		velocity = velocity.normalized() * speed
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
func update_health(new_value):
	health = new_value
	if health > 100:
		health = 100
	elif health <= 0:
		health = 0
		get_tree().paused = false
		if get_tree().change_scene("res://Scenes/Menus/GameOver.tscn") != OK:
			print("An error occured while trying to switch to GameOver scene")
	
	emit_signal("health_changed", health)
	
func take_damage(count):
	if not is_immune:
		update_health(health - count)
		emit_signal("health_changed", health)
	
func get_money(count):
	money += count
	emit_signal("money_changed", money)
	emit_signal("coin_collected")
	
func _on_StorePopup_buy_injection():
	if money >= 20:
		money -= 20
		speed = 400
		$"../SpeedBoostTimer".start()
		emit_signal("set_player_effect_hud", "boost", false)
		emit_signal("money_changed", money)

func _on_StorePopup_buy_first_aid_kit():
	if money >= 30:
		money -= 30
		update_health(health + 10)
		emit_signal("money_changed", money)

func _on_StorePopup_buy_pills():
	if money >= 60:
		money -= 60
		if randi() % 100 + 1 < 20:
			update_health(health - 30)
		else:
			update_health(health + 30)
		emit_signal("money_changed", money)

func _on_StorePopup_buy_mask():
	if money >= 80:
		money -= 80
		is_immune = true
		$"../ImmuneTimer".start()
		emit_signal("set_player_effect_hud", "immunity", false)
		emit_signal("money_changed", money)

func _on_SpeedBoostTimer_timeout():
	speed = 200
	emit_signal("set_player_effect_hud", "boost", true)

func _on_ImmuneTimer_timeout():
	is_immune = false
	emit_signal("set_player_effect_hud", "immunity", true)
