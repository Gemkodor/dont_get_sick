extends Node

const API_URL = "http://127.0.0.1:5000"

# Game data
var pseudo = "Player"
var score = 0

# Settings
var music_activated = true

func create_request():
	var http_request = HTTPRequest.new()
	self.add_child(http_request)
	return http_request
