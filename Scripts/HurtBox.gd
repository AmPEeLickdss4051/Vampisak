class_name HurtBox
extends Area3D

signal damaged(damage: int)

@export var defense = 0
@export_enum("Enemy", "Player") var team: String = "Enemy"

func hurt(hit_box: HitBox) -> int:
	var damage: int = max(0,hit_box.damage - defense)
	damaged.emit(damage)
	return damage
