extends Node2D

export (PackedScene) var Villager
export (PackedScene) var Coin

onready var store = $StorePopup

var screen_size
var HUD_SIZE = 93
var current_nb_coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.score = 0
	screen_size = get_viewport().size
	if Global.music_activated:
		$Music.play()
	for _i in range(Global.INITIAL_NUMBER_OF_VILLAGERS):
		add_villager(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().paused = true
		self.store.show()

func get_initial_position():
	# Possible start positions are outside the screen (left/right and above/below)
	var possibles_pos_x = [-10, screen_size.x + 10]
	var possibles_pos_y = [-10, screen_size.y + 10]

	var start_x
	var start_y

	if randi() % 2 == 0:
		# Left or right villager 
		start_x = possibles_pos_x[randi() % 2]
		start_y = randi() % int(screen_size.y)
	else:
		# Top or left villager
		start_x = randi() % int(screen_size.x)
		start_y = possibles_pos_y[randi() % 2]
		
	return [start_x, start_y]
	
func add_villager(infected):
	var new_villager = Villager.instance()
	var start_pos = get_initial_position()
	new_villager.position.x = start_pos[0]
	new_villager.position.y = start_pos[1]
	
	if infected:
		new_villager.is_infected = true
	
	add_child(new_villager)

func _on_NewVillagerTimer_timeout():
	add_villager(false)

func _on_NewInfectedVillagerTimer_timeout():
	add_villager(true)

func _on_NewCoinTimer_timeout():
	if current_nb_coins < Global.MAX_COINS_DISPLAYED:
		var new_coin = Coin.instance()
		new_coin.position.x = rand_range(50, int(screen_size.x) - 50)
		new_coin.position.y = rand_range(HUD_SIZE, screen_size.y - 50)
		current_nb_coins += 1
		add_child(new_coin)

func _on_Player_coin_collected():
	current_nb_coins -= 1
