extends Sprite2D
## Mute button

signal button_pressed

@onready var _released_texture: Texture = load("res://assets/sprites/mute_button_released.png")
@onready var _pressed_texture: Texture = load("res://assets/sprites/mute_button_pressed.png")
@onready var _audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var _area: Area2D = $Area2D
@onready var _should_play_sounds: bool = !AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))

func _ready() -> void:
	_update_texture()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_should_play_sounds = !_should_play_sounds
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !_should_play_sounds)
		_audio.play()
		_update_texture()
		_area.set_deferred("monitoring", false)
		button_pressed.emit()

func reset_button() -> void:
	_area.monitoring = true
	_update_texture()

func _update_texture() -> void:
	texture = _released_texture if _should_play_sounds else _pressed_texture
