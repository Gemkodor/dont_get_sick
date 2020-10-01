extends Node

onready var loading_scores = $Control/Scores/Loading
onready var scores = $Control/Scores/Content
onready var best_score_lbl = $Control/Scores/Content/BestScoreLbl


func _ready():
	randomize()
	self.loading_scores.show()
	self.scores.hide()
	Global.send_request("scores/" + str(Global.NB_SCORES_DISPLAYED_HOME), HTTPClient.METHOD_GET, String(), self, "_on_get_scores_completed")
	

func _on_PlayBtn_pressed():
	self.call_deferred("free")
	get_tree().change_scene("res://Scenes/Menus/PlayerCreation.tscn")


func _on_Options_pressed():
	self.call_deferred("free")
	if get_tree().change_scene("res://Scenes/Menus/Options.tscn") != OK:
		print("An unexpected error occured while trying to switch to the Options scene")


func _on_ScoresBtn_pressed():
	self.call_deferred("free")
	if get_tree().change_scene("res://Scenes/Menus/Scores.tscn") != OK:
		print("An unexpected error occured while trying to switch to the Scores scene")


func _on_Quit_pressed():
	get_tree().quit()


func _on_get_scores_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		self.loading_scores.hide()
		self.scores.show()
		var data = Global.get_json_from_response(body)
		
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
