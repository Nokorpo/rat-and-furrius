extends Button
## Used in main menu to define buttons to load levels

signal load_level(scene)

@export var scene:PackedScene

func _on_pressed() -> void:
	load_level.emit(scene)
