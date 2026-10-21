extends Node2D

# TODO: Quem cuida das scenes do player é o game

var enemy_swarm: EnemySwarm
var player: Player

# TODO: snake_case
var bossLeftSpawnPosition: Marker2D
var bossRightSpawnPosition: Marker2D

@export var log_game_events: bool = false

# NOTE: Maneira mais correta/segura/prática de pegar uma dependência filha
#@onready var spawn_boss_timer: Timer = %SpawnBossTimer

var spawnBossTimer:Timer 

func _ready() -> void:
	enemy_swarm = %EnemySwarm
	player = %Player
	spawnBossTimer = %SpawnBossTimer
	bossLeftSpawnPosition = %BossLeftSpawnPosition
	bossRightSpawnPosition = %BossRightSpawnPosition

 
# NOTE: Solução mais simples de signals sem lambda, usando conexão direta com 
# a aba de signals 
func _on_enemy_swarm_enemy_died(enemy: Enemy, enemy_type: EnemyGroup.EnemyType) -> void:
	# Evitei usar um Autoload para EnemyType e por tanto ele ficou no EnemyGroup
	if log_game_events:
		print("enemy %s of type %s died" % [enemy.name, EnemyGroup.EnemyType.find_key(enemy_type)])


func _on_player_died(life_left: int) -> void:
	if life_left <= 0:
		print("Game over!")


func _on_spawn_boss_timer_timeout() -> void:
	var spawn_positions:Array[Marker2D] = [bossLeftSpawnPosition, bossRightSpawnPosition]
	var random_spawn_position: Marker2D = spawn_positions.get(randi_range(0,1))
