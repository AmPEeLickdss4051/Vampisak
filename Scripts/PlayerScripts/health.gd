extends ProgressBar

@onready var player: CharacterBody3D = $"../.."


func _ready() -> void:
	max_value = player.MAX_HEALTH
	value = max_value

func _on_player_health_changed(new_health: Variant) -> void:
	value = new_health
