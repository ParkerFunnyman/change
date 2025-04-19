extends Node2D

var coin_scene = preload("res://scenes/Coin.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		spawn_coin()

func spawn_coin():
	if coin_scene:
		var coin = coin_scene.instantiate()
		add_child(coin)
		coin.global_position = get_global_mouse_position()
