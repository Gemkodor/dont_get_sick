extends Node

const API_URL = "http://godot-games-web.herokuapp.com"
const MAX_COINS_DISPLAYED = 5
const INITIAL_NUMBER_OF_VILLAGERS = 3
const NB_SCORES_DISPLAYED = 10
const NB_SCORES_DISPLAYED_HOME = 5

# Game data
var pseudo = "Player"
var selected_player = "Betty"
var score = 0

# Settings
var music_activated = true

func create_request():
	var http_request = HTTPRequest.new()
	self.add_child(http_request)
	return http_request
