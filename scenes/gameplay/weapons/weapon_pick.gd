@tool
extends Node2D
class_name WeaponPick
## Weapons placed around the map that player can pick

enum weapon_types { red, green, blue }

const WEAPON_SPRITES := {
	weapon_types.red: "res://assets/sprites/sword_r.png",
	weapon_types.green: "res://assets/sprites/sword_g.png",
	weapon_types.blue: "res://assets/sprites/sword_b.png"
}

const WEAPON_COLORS := {
	weapon_types.red: Color("79304f"),
	weapon_types.green: Color("38907a"),
	weapon_types.blue: Color("3549a8")
}

const WEAPON_PITCH := {
	weapon_types.red: 1.5,
	weapon_types.green: 1.1,
	weapon_types.blue: .8
}

@export var current_weapon := weapon_types.red:
	set(value):
		$AudioStreamPlayer.pitch_scale = WEAPON_PITCH[current_weapon]
		current_weapon = value
		update_sprite(value)
@export var pickup_cooldown_time := 1.

var pick_particles = preload("res://scenes/gameplay/weapons/weapon_pick_particle.tscn")

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		pickup_cooldown()
		var player_weapon = body.change_weapon(current_weapon)
		var particles = pick_particles.instantiate()
		add_child(particles)
		particles.color = Color(WEAPON_COLORS[current_weapon])
		particles.emitting = true
		current_weapon = player_weapon
		$AnimationPlayer.play("pickup")
		$AnimationPlayer.seek(0)
		$AudioStreamPlayer.play()

func pickup_cooldown() -> void:
	$Area2D.set_deferred("monitoring", false)
	$Timer.start(pickup_cooldown_time)
	await $Timer.timeout
	$Area2D.set_deferred("monitoring", true)

func update_sprite(weapon_type: weapon_types) -> void:
	$Sprite.texture = load(WEAPON_SPRITES[weapon_type])
