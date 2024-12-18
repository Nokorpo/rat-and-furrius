extends Line2D

@export var length = 50
@export var gradient_red: Gradient
@export var gradient_green: Gradient
@export var gradient_blue: Gradient

func _process(_delta: float) -> void:
	global_position = Vector2(0, 0)
	global_rotation = 0
	
	var point = get_parent().global_position
	
	add_point(point)
	
	while get_point_count() > length:
		remove_point(0)

func change_gradient(weapon_type: WeaponPick.weapon_types) -> void:
	gradient = get_weapon_gradient(weapon_type)

func get_weapon_gradient(weapon_type: WeaponPick.weapon_types) -> Gradient:
	match weapon_type:
		WeaponPick.weapon_types.red:
			return gradient_red
		WeaponPick.weapon_types.green:
			return gradient_green
		WeaponPick.weapon_types.blue, _:
			return gradient_blue
