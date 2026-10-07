extends Node2D

func _ready() -> void:
	var bind_enemy_died_event = func (enemy: Enemy): 
		enemy.died.connect(_on_enemy_died)
	get_tree().get_nodes_in_group("enemy").map(bind_enemy_died_event)


func _on_enemy_died(enemy: Enemy):
	print(enemy)

# NOTE: Solução mais simples para o lambda abaixo
func _on_enemy_swarm_enemy_died(enemy: Enemy) -> void:
	pass # Replace with function body.
