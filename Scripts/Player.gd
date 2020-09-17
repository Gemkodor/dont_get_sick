extends KinematicBody2D

# Variables
export var speed = 200
export var is_immune = false
export var is_infected = false
export var max_health = 100

var health = max_health
var money = 0
var screen_size
var effects = {}

# Signals
signal health_changed(health)
signal money_changed(money)
signal coin_collected

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
	
func set_effect(effect, active):
	self.effects[effect] = active
	
func set_speed(new_speed):
	self.speed = new_speed
	
func is_effect_active(effect):
	if effect in self.effects:
		return self.effects[effect]
	
	return false

func take_damage(count):
	if not is_immune:
		update_health(health - count)
		emit_signal("health_changed", health)
	
func get_money(count):
	money += count
	emit_signal("money_changed", self.money)
	emit_signal("coin_collected")

func withdraw_money(amount):
	if self.money >= amount:
		self.money -= amount
		emit_signal("money_changed", self.money)
		return true
		
	return false
