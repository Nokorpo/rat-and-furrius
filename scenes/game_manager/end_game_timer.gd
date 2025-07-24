extends Timer
## Used in game manager to update UI showing the time left before the game ends

signal game_over

@onready var timer_label := %TimerValue
@onready var texture_progress_bar = %TimerProgressBar
@onready var animation_player = $"../Control/TextureRect/AnimationPlayer"
@onready var time_low_player = $"../SFXTimeLow"
@onready var time_up_player = $"../SFXTimeUp"
@onready var is_time_over: bool = false
var _tween: Tween

#TODO move animation handling to another node?

func _ready() -> void:
	EventBus.got_cheese.connect(add_time)

func _process(_delta: float) -> void:
	if is_time_over:
		return

	timer_label.text = "%3.2f s" % time_left
	texture_progress_bar.value = time_left

	if time_left < 4:
		animation_player.play("time_low", 10)
		if not time_low_player.playing:
			time_low_player.play()
	else:
		animation_player.play("RESET", 5)
		time_low_player.stop()

func add_time(time_to_add: float) -> void:
	var texture_rect = $"../Control/TextureRect"
	texture_rect.scale = Vector2(1.3, 1.3)
	if _tween == null:
		_tween = create_tween()
	else:
		_tween.kill()
		_tween = create_tween()
	
	_tween.tween_property(texture_rect, "scale", Vector2(1, 1), .5)
	start(time_left + time_to_add)

func _on_timeout() -> void:
	%TimerValue.text = "0.0 s"
	is_time_over = true
	animation_player.play("time_up")
	time_low_player.stop()
	time_up_player.play()
	await animation_player.animation_finished
	game_over.emit()
