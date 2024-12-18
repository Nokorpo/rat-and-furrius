extends RichTextLabel

const SCORES_FORMAT := """Best times:
%s

Last Time:
%s
"""
const TIME_FORMAT := "%3.2f s\n"
const CURRENT_TIME_STYLE := "[wave amp=30 freq=2][color=ea7984]%s[/color][/wave]"

var best_times := [1.2, 2.3, 3.4]
var current_time := 1.2

var current_time_position: float

func _ready() -> void:
	set_highscores()
	text = format_scores()

func set_highscores() -> void:
	best_times = HighscoreHolder.highscore_list
	current_time = HighscoreHolder.current
	current_time_position = HighscoreHolder.current_position

func format_scores() -> String:
	var best_times_text = ""
	for i in range(len(best_times)):
		var score = (TIME_FORMAT % best_times[i]).replace(".", " . ")
		if current_time_position == i:
			score = CURRENT_TIME_STYLE % score
		best_times_text += score
	
	var current_time_text = (TIME_FORMAT % current_time).replace(".", " . ")
	current_time_text = CURRENT_TIME_STYLE % current_time_text
	return SCORES_FORMAT % [best_times_text, current_time_text]
