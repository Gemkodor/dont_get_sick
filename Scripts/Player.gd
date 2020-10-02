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

onready var animated_sprite_betty = $AnimatedSpriteBetty
onready var animated_sprite_george = $AnimatedSpriteGeorge
onready var immunity_highlight = $ImmunityHighlight
var selected_player

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	self.set_player_animation()


func set_player_animation():
	if Global.selected_player == "George":
		self.selected_player = self.animated_sprite_george
		self.animated_sprite_betty.visible = false
	else:
		self.selected_player = self.animated_sprite_betty
		self.animated_sprite_george.visible = false


func set_player_lowlife_visual():
	var color = "#ffffff"
	if self.health <= 20:
		color = "#e41f1f"
	
	if Global.selected_player == "George":
		self.animated_sprite_george.self_modulate = color
	else:
		self.animated_sprite_betty.self_modulate = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		self.selected_player.animation = "right"
		velocity.x += 1
	elif Input.is_action_pressed("ui_left"):
		self.selected_player.animation = "left"
		velocity.x -= 1
	elif Input.is_action_pressed("ui_up"):
		self.selected_player.animation = "up"
		velocity.y -= 1
	elif Input.is_action_pressed("ui_down"):
		self.selected_player.animation = "down"
		velocity.y += 1
		
	if velocity.length() > 0:
		self.selected_player.play()
		velocity = velocity.normalized() * speed
	else:
		self.selected_player.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if "immune" in self.effects and self.effects["immune"]:
		self.immunity_highlight.show()
	else:
		self.immunity_highlight.hide()
		# Reset color
		self.immunity_highlight.color = "#d4a721"


func update_health(new_value):
	health = new_value
	if health > 100:
		health = 100
	elif health <= 0:
		health = 0
		get_tree().paused = false
		self.call_deferred("free")
		if get_tree().change_scene("res://Scenes/Menus/GameOver.tscn") != OK:
			print("An error occured while trying to switch to GameOver scene")
	
	self.set_player_lowlife_visual()
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


func _on_StorePopup_ending_of_player_effect(effect):
	match effect:
		"immune":
			self.immunity_highlight.color = "#e41f1f"
