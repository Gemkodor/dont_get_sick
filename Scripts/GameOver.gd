extends MarginContainer

const NB_SCORES_DISPLAYED = 3

func _ready():
	self.save_score()
	self.get_scores()
	$VBoxContainer/HBoxContainer/Label.text = "Perdu ! Vous avez fait un score de : " + str(Global.score)

func get_scores():
	var http_request = Global.create_request()
	http_request.connect("request_completed", self, "_on_get_scores_completed")
	
	# Build request parameters
	var url = Global.API_URL + "/scores"
	var headers = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_GET
	var ssl_validate_domain = true
	http_request.request(url, headers, ssl_validate_domain, method)

func save_score():
	var player_score = {
		'pseudo': Global.pseudo,
		'score': Global.score
	}

	# Create HTTP Request
	var http_request = Global.create_request()

	# Build the request parameters
	var url = Global.API_URL + "/scores/save"
	var headers = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_POST
	var data = JSON.print(player_score)
	var ssl_validate_domain = true
	
	var result = http_request.request(url, headers, ssl_validate_domain, method, data)
	if result != OK:
		print("Failed to send the score to the server : %d" % result)

func _on_get_scores_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse(body.get_string_from_utf8())
		var data = json.result
		
		if "best_score" in data:
			var best_score = data['best_score']
			if best_score:
				$VBoxContainer/Scores/BestScoreLbl.text = "Meilleur score : %s (%s)" % [best_score.pseudo, best_score.score]
			
		if len(data['scores']) >= self.NB_SCORES_DISPLAYED:
			var i = 0
			while i < NB_SCORES_DISPLAYED:
				var score = data['scores'][i]
				var label = Label.new()
				label.add_font_override("font", load("res://resources/classic_font.tres"))
				label.align = Label.ALIGN_CENTER
				label.text = "%s - %s" % [score.pseudo, score.score]
				$VBoxContainer/Scores.add_child(label)
				i += 1
				
func _on_Button_pressed():
	if get_tree().change_scene("res://Scenes/Game.tscn") != OK:
		print("An unexpected error occured while trying to switch to Game scene")

func _on_BackToMenu_pressed():
	if get_tree().change_scene("res://Scenes/Menus/MainScene.tscn") != OK:
		print("An unexpected error occured while trying to switch to Main scene")
