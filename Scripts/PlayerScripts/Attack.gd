extends Node3D

@export var speed = 10.0

@onready var hit_box: HitBox = $HitBox

var velocity = Vector3.ZERO

func _ready():
	pass

func setup(direction: Vector3):
	velocity = direction * speed
	if direction.length() > 0.1:
		look_at(global_position + direction, Vector3.UP)

func _process(delta):
	global_position += velocity * delta
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_hit_box_area_entered(area: Area3D) -> void:
	var hurt_box: HurtBox = area as HurtBox
	if hurt_box.team != hit_box.team:
		queue_free()
		
func _on_hit_box_body_entered(body: Node3D) -> void:
	queue_free()
