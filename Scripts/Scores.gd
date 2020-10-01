extends Control

onready var scores_box = $MarginContainer/VBoxContainer/Scores/LastScores
onready var highscores_box = $MarginContainer/VBoxContainer/Scores/HighScores

func _ready():
	Global.send_request("scores", HTTPClient.METHOD_GET, String(), self, "_on_get_scores_completed")
	Global.send_request("highscores", HTTPClient.METHOD_GET, String(), self, "_on_get_highscores_completed")


func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE) and get_tree().change_scene("res://Scenes/Menus/MainScene.tscn") != OK:
		print("An unexpected error occured while trying to switch to Main scene")


func _on_get_scores_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var data = Global.get_json_from_response(body)
		var i = 0
		if data:
			while i <= (len(data["scores"]) - 1) and i < Global.NB_SCORES_DISPLAYED:
				var score = data["scores"][i]
				var label = Label.new()
				label.align = Label.ALIGN_CENTER
				label.add_font_override("font", load("res://resources/classic_font.tres"))
				label.text = "%s - %s" % [score.pseudo, score.score]
				self.scores_box.add_child(label)
				i += 1


func _on_get_highscores_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var data = Global.get_json_from_response(body)
		var i = 0
		if data:
			while i <= (len(data) - 1) and i < Global.NB_SCORES_DISPLAYED:
				var score = data[i]
				var label = Label.new()
				label.align = Label.ALIGN_CENTER
				label.add_font_override("font", load("res://resources/classic_font.tres"))
				label.text = "%s - %s" % [score[0], score[1]]
				self.highscores_box.add_child(label)
				i += 1


func _on_BackBtn_pressed():
	self.call_deferred("free")
	get_tree().change_scene("res://Scenes/Menus/MainScene.tscn")
