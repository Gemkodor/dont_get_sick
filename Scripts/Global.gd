extends Node

const API_URL = "http://godot-games-web.herokuapp.com/"
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
var display_resume_game_timer = true
var resume_game_timer_duration = 100

# Networking methods
func create_request():
	var http_request = HTTPRequest.new()
	self.add_child(http_request)
	return http_request


func send_request(endpoint, method, data, sender, callback):
	var http_request = self.create_request()
	var url = self.API_URL + endpoint
	var headers = ["Content-Type: application/json"]
	var ssl_validate_domain = true
	http_request.connect("request_completed", sender, callback)
	http_request.request(url, headers, ssl_validate_domain, method, JSON.print(data))


func get_json_from_response(body):
	return JSON.parse(body.get_string_from_utf8()).result
