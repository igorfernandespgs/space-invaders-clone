extends Node2D

var enemy_swarm: EnemySwarm
var player: Player

@export var log_game_events: bool = false

func _ready() -> void:
	enemy_swarm = %EnemySwarm
	player = %Player

 
# NOTE: Solução mais simples de signals sem lambda, usando conexão direta com 
# a aba de signals 
func _on_enemy_swarm_enemy_died(enemy: Enemy, enemy_type: EnemyGroup.EnemyType) -> void:
	# Evitei usar um Autoload para EnemyType e por tanto ele ficou no EnemyGroup
	if log_game_events:
		print("enemy %s of type %s died" % [enemy.name, EnemyGroup.EnemyType.find_key(enemy_type)])


func _on_player_died(life_left: int) -> void:
	if life_left <= 0:
		print("Game over!")
