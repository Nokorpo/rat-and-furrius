extends Sprite2D
# Used in levels to increase the time the player has left

@export var time_to_add: float = 1
@export var pickup_color := Color.WHITE
var pick_particles = preload("res://scenes/gameplay/props/cheese_pick_particle.tscn")

func _on_player_entered_enemy_weak_spot(player) -> void:
	$Area2D.set_deferred("monitoring", false)
	EventBus.got_cheese.emit(time_to_add)
	$AudioStreamPlayer.pitch_scale = randf_range(.8, 1.2)
	$AnimationPlayer.play("pickup")
	$AudioStreamPlayer.play()

func play_particle():
	var particles = pick_particles.instantiate()
	get_parent().add_child(particles)
	particles.position = position
	particles.color = pickup_color
	particles.emitting = true

func _on_audio_stream_player_finished():
	queue_free()
