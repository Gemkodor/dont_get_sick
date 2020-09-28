extends Control

onready var game_over_lbl = $MarginContainer/VBoxContainer/HBoxContainer/GameOverLbl
onready var best_score_lbl = $MarginContainer/VBoxContainer/Scores/BestScoreLbl
onready var current_player_best_score_lbl = $MarginContainer/VBoxContainer/Scores/CurrentPlayerBestCoreLbl
onready var scores_box = $MarginContainer/VBoxContainer/Scores


func _ready():
	self.game_over_lbl.text = "Perdu ! Vous avez fait un score de : " + str(Global.score)

	# Save new score
	self.save_score()


func save_score():
	var player_score = {
		'pseudo': Global.pseudo,
		'score': Global.score
	}

	Global.send_request("scores/save", HTTPClient.METHOD_POST, player_score, self, "_on_save_scores_completed")


func _on_save_scores_completed(result, response_code, headers, body):
	# Get all the scores when new score is saved
	Global.send_request("scores/" + str(Global.NB_SCORES_DISPLAYED), HTTPClient.METHOD_GET, String(), self, "_on_get_scores_completed")
	Global.send_request("best_score/" + Global.pseudo, HTTPClient.METHOD_GET, String(), self, "_on_get_best_score_completed")


func _on_get_scores_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var data = Global.get_json_from_response(body)
		
		if "best_score" in data:
			var best_score = data['best_score']
			self.best_score_lbl.text = "Meilleur score : %s (%s)" % [best_score.pseudo, best_score.score]
			
		var i = 0
		while i <= (len(data['scores']) - 1) and i < Global.NB_SCORES_DISPLAYED:
			var score = data['scores'][i]
			var label = Label.new()
			label.add_font_override("font", load("res://resources/classic_font.tres"))
			label.align = Label.ALIGN_CENTER
			label.text = "%s - %s" % [score.pseudo, score.score]
			self.scores_box.add_child(label)
			i += 1


func _on_get_best_score_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var data = Global.get_json_from_response(body)
		if data and data.score:
			self.current_player_best_score_lbl.text = "Meilleur score personnel : " + str(data.score)


func _on_Button_pressed():
	self.call_deferred("free")
	if get_tree().change_scene("res://Scenes/Game.tscn") != OK:
		print("An unexpected error occured while trying to switch to Game scene")


func _on_BackToMenu_pressed():
	self.call_deferred("free")
	if get_tree().change_scene("res://Scenes/Menus/MainScene.tscn") != OK:
		print("An unexpected error occured while trying to switch to Main scene")
