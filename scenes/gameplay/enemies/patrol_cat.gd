extends Path2D
class_name Cat
## Used in enemy cats to follow a path and react to signals

signal player_caught

enum Weakness { all, red, green, blue }

@export var speed:float = 100.
@export var weakness: Weakness = Weakness.red

@export_group("Pulse")
## Maximum size of the pulse
@export var size_max := 3.0
## Time that the pulse stays off
@export var time_off := 1.0
## Time in the animation transition
@export var time_animation := 1.0
## Time trhat the pulse stays on
@export var time_on := 1.0

var enabled: bool = true

func _ready() -> void:
	%Sprite2D.set_sprite(weakness)
	%WeakSpot.weakness = weakness
	$PathFollow2D/Vision.scale = Vector2(0, 0)
	animate_pulse()

func connect_player_caught(level_manager):
	if level_manager.has_method("_on_player_caught"):
		player_caught.connect(level_manager._on_player_caught)

func _physics_process(delta: float) -> void:
	if enabled:
		$PathFollow2D.progress += speed * delta

func _on_player_entered_enemy_vision() -> void:
	player_caught.emit()

func _on_player_entered_enemy_weak_spot() -> void:
	enabled = false
	$PathFollow2D/Vision/Area2D.monitoring = false
	%WeakSpot.set_deferred("monitoring", false)
	TEMPORAL_play_killed_sound()
	queue_free()

func animate_pulse():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	var vision = $PathFollow2D/Vision
	tween.tween_property(vision, "scale", Vector2(size_max, size_max), time_animation)
	await tween.finished
	await get_tree().create_timer(time_on).timeout
	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(vision, "scale", Vector2(0, 0), time_animation)
	await tween.finished
	await get_tree().create_timer(time_off).timeout
	animate_pulse()

func TEMPORAL_play_killed_sound():
	var audio = %AudioStreamPlayer
	audio.play()
	audio.reparent(get_tree().root)
	audio.finished.connect(audio.queue_free)
