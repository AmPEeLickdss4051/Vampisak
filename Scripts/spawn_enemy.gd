class_name SpawnEnemy
extends Node3D

const Unit = preload("res://Scenes/EnemyScene/basic_enemy.tscn")

var gridmap_node: GridMap
var player_node: CharacterBody3D
var spawn_radius: float = 5.0


func _ready() -> void:
	var player = get_tree().get_nodes_in_group("player")
	if player.size() > 0:
		player_node = player[0]
	else:
		set_process(false)
		
	gridmap_node = get_tree().get_first_node_in_group("gridmap")


func get_random_position_in_gridmap() -> Vector3:
	var used_cells = gridmap_node.get_used_cells()
	
	#var floor_cells = []
	#var min_y = 0
	#for cell in used_cells:
		#if cell.y == min_y:
			#floor_cells.append(cell)
	
	#if floor_cells.size() == 0:
		#floor_cells = used_cells
	
	var random_cell = used_cells[randi() % used_cells.size()]
	
	var world_position = gridmap_node.to_global(gridmap_node.map_to_local(random_cell))
	world_position.y = 2.0
	
	#if gridmap_node.cell_size != Vector3.ZERO:
		#var cell_size = gridmap_node.cell_size
		#world_position.x += randf_range(-cell_size.x / 3, cell_size.x / 3)
		#world_position.z += randf_range(-cell_size.z / 3, cell_size.z / 3)
	
	#world_position.y = 0.1  # Небольшое возвышение над полом
	#print("Финальная позиция спавна: ", world_position)
	
	return world_position


func _on_timer_timeout() -> void:
	var unit = Unit.instantiate()
	var spawn_position = get_random_position_in_gridmap()
	
	if spawn_position:
		get_parent().add_child(unit)
		unit.global_position = spawn_position
