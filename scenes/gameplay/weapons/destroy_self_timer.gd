extends Node
## Destroys self after a timer ends

func _on_timer_timeout():
	queue_free()
