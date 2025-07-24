extends Sprite2D
## Generic button, emits "button_pressed" signal when clicked

signal button_pressed

@onready var _released_texture: Texture = load("res://assets/sprites/buttons/button_released.png")
@onready var _pressed_texture: Texture = load("res://assets/sprites/buttons/button_pressed.png")
@onready var _audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var _area: Area2D = $Area2D

func reset_button() -> void:
	_area.monitoring = true
	texture = _released_texture

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_audio.play()
		texture = _pressed_texture
		_area.set_deferred("monitoring", false)
		button_pressed.emit()
