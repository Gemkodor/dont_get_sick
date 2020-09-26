extends Node

onready var scores = $Control/Scores
onready var best_score_lbl = $Control/Scores/BestScoreLbl

func _ready():
	randomize()
	self.load_last_scores()


func _on_PlayBtn_pressed():
	self.call_deferred("free")
	get_tree().change_scene("res://Scenes/Menus/PlayerCreation.tscn")


func _on_Options_pressed():
	self.call_deferred("free")
	if get_tree().change_scene("res://Scenes/Menus/Options.tscn") != OK:
		print("An unexpected error occured while trying to switch to the Options scene")


func _on_Quit_pressed():
	get_tree().quit()


func load_last_scores():
	var http_request = Global.create_request()
	http_request.connect("request_completed", self, "_on_get_scores_completed")
	
	# Build request parameters
	var url = Global.API_URL + "/scores"
	var headers = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_GET
	var ssl_validate_domain = true
	http_request.request(url, headers, ssl_validate_domain, method)


func _on_get_scores_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse(body.get_string_from_utf8())
		var data = json.result
		
		if "best_score" in data:
			var best_score = data['best_score']
			self.best_score_lbl.text = "%s - %s" % [best_score.pseudo, best_score.score]
			
		var i = 0
		while i <= (len(data['scores']) - 1) and i < Global.NB_SCORES_DISPLAYED_HOME:
			var score = data['scores'][i]
			var label = Label.new()
			label.add_font_override("font", load("res://resources/classic_font.tres"))
			label.text = "%s - %s" % [score.pseudo, score.score]
			self.scores.add_child(label)
			i += 1
