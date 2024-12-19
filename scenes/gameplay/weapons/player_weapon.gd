@tool
extends Node2D
## The weapon that player is holding

@export var current_weapon := WeaponPick.weapon_types.red:
	set(value):
		current_weapon = value
		update_sprite(value)

func update_sprite(weapon_type: WeaponPick.weapon_types) -> void:
	$Sprite.texture = load(WeaponPick.WEAPON_SPRITES[weapon_type])
