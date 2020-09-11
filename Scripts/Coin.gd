extends Area2D

onready var player = $"../Player"

func _on_Coin_body_entered(body):
	if body.get_name() == "Player":
		player.get_money(5)
	queue_free()
