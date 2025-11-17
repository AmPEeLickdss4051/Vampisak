class_name EnemyBasic
extends CharacterBody3D

@export var HEALTH = 10
@export var SPEED = 5.0

@onready var hurt_box: HurtBox = $HurtBox

var player_node: CharacterBody3D

func _ready() -> void:
	hurt_box.damaged.connect(take_damage)
	find_player()

func _process(delta: float) -> void:
	move_to_player()
	move_and_slide()

func take_damage(damage_amount: int):
	HEALTH -= damage_amount
	print(HEALTH)
	if HEALTH <= 0:
		death()

func death():
		queue_free()

func find_player():
	var player = get_tree().get_nodes_in_group("player")
	if player.size() > 0:
		player_node = player[0]
	else:
		set_process(false)


func move_to_player():
	if not is_instance_valid(player_node):
		find_player()
		if not is_instance_valid(player_node):
			velocity = Vector3.ZERO
			return
			
	var player_gl_pos = player_node.global_position
	var direction = (player_gl_pos - global_position).normalized()
	if direction != Vector3.ZERO:
		velocity = direction * SPEED
		var look_pos = Vector3(player_gl_pos.x, global_position.y, player_gl_pos.z)
		look_at(look_pos, Vector3.UP)
	else:
		velocity = Vector3.ZERO
