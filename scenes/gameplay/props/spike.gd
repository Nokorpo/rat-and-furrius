extends Area2D
## Spike that damages the player

signal player_caught

func connect_player_caught(level_manager: LevelManager) -> void:
	player_caught.connect(level_manager._on_player_caught)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_caught.emit()
