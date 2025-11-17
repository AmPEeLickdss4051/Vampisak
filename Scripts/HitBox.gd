class_name HitBox
extends Area3D

signal hit_landed(damage: int)

@export var damage = 10
@export_enum("Enemy", "Player") var team: String = "Enemy"

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func hit(hurt_box: HurtBox) -> void:
	if hurt_box and hurt_box.team != team:
		hit_landed.emit(hurt_box.hurt(self))

func _on_area_entered(area3d: Area3D) -> void:
	if area3d is HurtBox:
		hit(area3d as HurtBox)
