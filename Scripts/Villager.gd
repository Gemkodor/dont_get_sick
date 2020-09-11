extends Area2D

export var is_infected = false
export var RISK_TO_INFECT = 60

var screen_size
var speed = 100
var direction_x
var direction_y
var infected_texture = preload("res://assets/sprites/sick-villager.png")

onready var player = $"../Player"

func _ready():
	screen_size = get_viewport_rect().size
	check_if_infected()
	initialize_directions()
	
func _process(delta):
	check_if_infected()
	update_position(delta)
	set_new_direction()

func initialize_directions():
	var possibles_direction_x = ["right", "left"]
	var possibles_direction_y = ["up", "down"]
	direction_x = possibles_direction_x[randi() % 2]
	direction_y = possibles_direction_y[randi() % 2]

func check_if_infected():
	if is_infected:
		$Sprite.set_texture(infected_texture)

func update_position(delta):
	var velocity = Vector2()
	
	if direction_x == "right":
		velocity.x += 1
	else:
		velocity.x -= 1

	if direction_y == "up":
		velocity.y -= 1
	else:
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta

func set_new_direction():
	if position.x > screen_size.x:
		direction_x = "left"
	if position.x < 0:
		direction_x = "right"

	if position.y > screen_size.y:
		direction_y = "up"
	if position.y < 0:
		direction_y = "down"

func _on_Villager_area_entered(area):
	if area.is_in_group("villagers") and not area.is_infected and self.is_infected:
		area.is_infected = (randi() % 100) < RISK_TO_INFECT 

func _on_Villager_body_entered(body):
	if body.get_name() == "Player" and self.is_infected:
		player.take_damage(10)
