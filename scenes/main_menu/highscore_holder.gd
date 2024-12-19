extends Node

const MAX_HIGHSCORE_LIST_SIZE = 3
var highscore_list: Array[float] = []

enum POSITION_IN_HIGHSCORE { FIRST=0, SECOND=1, THIRD=2, OUTSIDE=-1}
var current_position: POSITION_IN_HIGHSCORE = POSITION_IN_HIGHSCORE.OUTSIDE

var current: float = 0.0:
	set(value):
		current = value
		current_position = POSITION_IN_HIGHSCORE.OUTSIDE
		for i in range(len(highscore_list)):
			if value <= highscore_list[i]:
				current_position = i as POSITION_IN_HIGHSCORE
				highscore_list.insert(i, value)
				highscore_list.resize(min(highscore_list.size(), 3))
				_save_highscores()
				return
		if highscore_list.size() < MAX_HIGHSCORE_LIST_SIZE:
			current_position = highscore_list.size() as POSITION_IN_HIGHSCORE
			highscore_list.append(value)
			_save_highscores()

func _ready() -> void:
	_load_highscores()

func _save_highscores() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_var(highscore_list)

func _load_highscores() -> void:
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	if save_game:
		var previous_highscore_list: Array = save_game.get_var()
		for highscore in previous_highscore_list:
			highscore_list.append(highscore)
