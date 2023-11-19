@tool
extends Node2D

@export var current_weapon := WeaponPick.weapon_types.red:
	set(value):
		current_weapon = value
		update_sprite(value)

func update_sprite(weapon_type: WeaponPick.weapon_types):
	$Sprite.texture = load(WeaponPick.WEAPON_SPRITES[weapon_type])
