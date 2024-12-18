extends Area2D
## Used in levels to signal a player reached the end
## Also used in cheese to signal the player got the cheese

signal player_entered_enemy_weak_spot(player)
signal player_used_wrong_color_to_attack

var weakness: Cat.Weakness

func is_weak_against(value: Cat.Weakness) -> bool:
	if value == WeaponPick.weapon_types.red and weakness == Cat.Weakness.red:
		return true
	if value == WeaponPick.weapon_types.green and weakness == Cat.Weakness.green:
		return true
	if value == WeaponPick.weapon_types.blue and weakness == Cat.Weakness.blue:
		return true
	elif weakness == Cat.Weakness.all:
		return true
	else:
		return false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("get_current_weapon"):
			if is_weak_against(body.get_current_weapon()):
				player_entered_enemy_weak_spot.emit(body)
			else:
				player_used_wrong_color_to_attack.emit()
