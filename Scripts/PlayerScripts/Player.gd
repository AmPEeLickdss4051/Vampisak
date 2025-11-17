extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var ATTACK_COOLDOWN = 0.5
@export var HEALTH = 100

@onready var camera: Camera3D = $Camera3D
@onready var animation: AnimationTree = $"X Bot/AnimationTree"
@onready var x_bot: Node3D = $"X Bot"
@onready var pos: Node3D = $Attack/pos
@onready var hurt_box: HurtBox = $HurtBox

const ATTACK = preload("uid://6c1rsnjhpgo1")

var direction = Vector3.ZERO
var ray_origin = Vector3()
var ray_end = Vector3()
var can_attack = true

enum {IDLE, WALK}
var CurrentAnim = IDLE

func _ready() -> void:
	add_to_group("player")
	hurt_box.damaged.connect(take_damage)

func _process(delta: float) -> void:
	handle_anim()
	Movement()
	
	if Input.is_action_pressed("Attack") and can_attack:
		perform_attack()
		
	move_and_slide()

func perform_attack():
	var inst = ATTACK.instantiate()
	get_parent().add_child(inst)
	var target = look_at_mouse()
	inst.position = pos.global_position
	if target:
		var horizontal = Vector3(target.x, pos.global_position.y, target.z)
		var shoot_direction = (horizontal - pos.global_position).normalized()
		if inst.has_method("setup"):
			inst.setup(shoot_direction)
		
	can_attack = false
	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true

func Movement():
	var input_dir = Input.get_vector("Left", "Right", "UP", "Down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		var target_angel = atan2(direction.x, direction.z)
		var current_angel = x_bot.global_rotation.y
		x_bot.global_rotation.y = lerp_angle(current_angel, target_angel, 0.2)
		CurrentAnim = WALK
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		CurrentAnim = IDLE

func look_at_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	ray_origin = camera.project_ray_origin(mouse_pos)
	ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	var space_state = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.new()
	params.from = ray_origin
	params.to = ray_end
	var result = space_state.intersect_ray(params)
	if result:
		var collision_point = result.position
		var look_at_me = Vector3(collision_point.x, 0, collision_point.z)
		return look_at_me
	return null

func handle_anim():
	match CurrentAnim:
		IDLE:
			animation.set("parameters/Movement/transition_request", "Idle")
		WALK:
			animation.set("parameters/Movement/transition_request", "Walk")

func take_damage(damage_amount: int):
	HEALTH -= damage_amount
	print(HEALTH)
	if HEALTH <= 0:
		death()

func death():
	queue_free()
