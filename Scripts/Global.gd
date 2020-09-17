extends Node

var score = 0
var savegame = File.new()
var save_path = "user://scores.save"
var save_data = {"highscore": 0}

# Settings
var music_activated = false

func _ready():
	if not savegame.file_exists(save_path):
		create_save()
	
func create_save():
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func save():
	var previous_score = read_savegame()
	if previous_score < score:
		save_data["highscore"] = score
		savegame.open(save_path, File.WRITE)
		savegame.store_var(save_data)
		savegame.close()
	
func read_savegame():
	savegame.open(save_path, File.READ)
	save_data = savegame.get_var()
	savegame.close()
	return save_data["highscore"]
