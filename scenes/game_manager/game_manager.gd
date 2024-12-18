extends Node
## Used in main menu/game to manage loading/freeing levels in order

@onready var curtain = $Control/Curtain
var levels: Array[PackedScene]
var current_level_index: int = 0
var current_level: Node
var is_restarting: bool
var run_start: float

func _ready() -> void:
	run_start = Time.get_unix_time_from_system()
	load_level(levels[0])
	is_restarting = false

func _input(event: InputEvent) -> void:
	if not is_restarting and event.is_action_pressed("restart_game"):
		is_restarting = true
		if curtain.is_playing():
			await curtain.finished
		call_deferred("load_menu")
		get_viewport().set_input_as_handled()

func load_next_level() -> void:
	current_level_index += 1
	if levels.size() > current_level_index:
		unload_current_level()
		load_level(levels[current_level_index])
	else:
		unload_current_level()
		load_game_finished()

#TODO: rename to game over
func load_menu() -> void:
	curtain.reparent(get_tree().get_root())
	curtain.play_animation()
	curtain.finished.connect(curtain.queue_free)
	await curtain.change_scene_now
	load_end_scene(load("res://scenes/main_menu/start_menu.tscn"))
	queue_free()

#TODO: rename to victory
func load_game_finished() -> void:
	curtain.reparent(get_tree().get_root())
	curtain.play_animation()
	curtain.finished.connect(curtain.queue_free)
	await curtain.change_scene_now
	HighscoreHolder.current = Time.get_unix_time_from_system() - run_start
	load_end_scene(load("res://scenes/main_menu/end_menu.tscn"))
	queue_free()

func load_end_scene(packed_scene: PackedScene) -> void:
	var scene = packed_scene.instantiate()
	get_tree().root.call_deferred("add_child", scene)
	
func unload_current_level() -> void:
	current_level.queue_free()

func reload_current_level(cheeses: Node) -> void:
	$SFXNextLevel.play()
	var last_level = current_level
	cheeses.call_deferred("reparent", self)
	load_level(levels[current_level_index])
	current_level.call_deferred("add_cheeses", cheeses)
	last_level.queue_free()

func load_level(scene: PackedScene) -> void:
	curtain.play_animation()
	current_level = scene.instantiate()
	if current_level.has_signal("level_finished"):
		current_level.level_finished.connect(load_next_level)
	if current_level.has_signal("restart_level"):
		current_level.restart_level.connect(reload_current_level)
	call_deferred("add_child", current_level)

func _on_game_over() -> void:
	load_menu()

func _on_end_game_timer_timeout() -> void:
	current_level.process_mode = Node.PROCESS_MODE_DISABLED
