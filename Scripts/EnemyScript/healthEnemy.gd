extends ProgressBar

@onready var basic_enemy: EnemyBasic = $"../.."


func _ready() -> void:
	max_value = basic_enemy.MAX_HEALTH
	value = max_value
	


func _on_basic_enemy_health_chenged(new_health: Variant) -> void:
	value = new_health
