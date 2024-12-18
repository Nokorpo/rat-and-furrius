extends Path2D
class_name Cat
## Used in enemy cats to follow a path and react to signals

signal player_caught
signal cat_died

enum Weakness { all, red, green, blue }
enum CatType { sleepy, patrol }

## Type of cat
@export var type: CatType
## Speed of the cat if it moves
@export var speed := 100.0
## Color that this cat is weak to
@export var weakness: Weakness = Weakness.red
## If true, vision cone will be reduced on vertical positions
@export var reduce_vertical_vision: bool = false

@export_group("Pulse")
## Time that the pulse stays off
@export var size_max := 3.0
## Delays the first pulse
@export var delay_first_pulse := 0.0
## Maximum size of the pulse
@export var time_off := 1.0
## Time in the animation transition
@export var time_animation := 1.0
## Time trhat the pulse stays on
@export var time_on := 1.0

var enabled: bool = true
var last_position

func _ready() -> void:
	%Sprite2D.set_sprite(weakness)
	%WeakSpot.weakness = weakness
	if type == CatType.sleepy:
		$PathFollow2D/Vision.scale = Vector2(0, 0)
		await get_tree().create_timer(delay_first_pulse).timeout
		animate_pulse()

func _process(_delta: float) -> void:
	if !reduce_vertical_vision or last_position == null or type != CatType.patrol:
		last_position = %Sprite2D.position
		return
	var velocity = %Sprite2D.position - last_position
	var direction = velocity.normalized()
	$PathFollow2D/Vision.scale.x = 0.12 * (1 - abs(direction.y))
	last_position = %Sprite2D.position

func connect_player_caught(level_manager: LevelManager) -> void:
	if level_manager.has_method("_on_player_caught"):
		player_caught.connect(level_manager._on_player_caught)

func connect_cat_counter(level_manager) -> void:
	if level_manager.has_method("_on_cat_died"):
		level_manager.cats_on_level += 1
		cat_died.connect(level_manager._on_cat_died)

func _physics_process(delta: float) -> void:
	if enabled:
		$PathFollow2D.progress += speed * delta

func _on_player_entered_enemy_vision() -> void:
	player_caught.emit()

func _on_player_entered_enemy_weak_spot(_player) -> void:
	enabled = false
	$PathFollow2D/Vision/Area2D.monitoring = false
	%WeakSpot.set_deferred("monitoring", false)
	TEMPORAL_play_killed_sound()
	cat_died.emit()
	$effects.position = $PathFollow2D/Vision.position
	$effects.look_at(get_global_mouse_position())
	$effects/AnimationPlayer.play("attack")
	await $effects/AnimationPlayer.animation_finished
	queue_free()

func animate_pulse() -> void:
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

func TEMPORAL_play_killed_sound() -> void:
	var audio = %AudioStreamPlayer
	audio.pitch_scale = randf_range(.9, 1.1)
	audio.play()
	audio.reparent(get_tree().root)
	audio.finished.connect(audio.queue_free)
