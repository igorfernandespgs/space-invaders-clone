extends Node2D

var enemy_swarm: EnemySwarm

func _ready() -> void:
	enemy_swarm = %EnemySwarm

 
#NOTE: Solução mais simples de signals sem lambda, usando conexão direta com 
# a aba de signals 
func _on_enemy_swarm_enemy_died(enemy: Enemy, enemy_type: EnemyGroup.EnemyType) -> void:
	# Evitei usar um Autoload para EnemyType e por tanto ele ficou no EnemyGroup
	print("enemy %s of type %s died" % [enemy.name, EnemyGroup.EnemyType.find_key(enemy_type)])
