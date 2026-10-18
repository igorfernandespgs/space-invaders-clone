@tool
@icon ("res://addons/at-icons/node2d/voxels.svg")
class_name EnemySwarm extends Node2D

#region Signal Declaration

signal enemy_died(enemy: Enemy, enemy_type: EnemyGroup.EnemyType)

#endregion

#region Exported Vars
## The maximum amount of shooters that can shoot every time
## that the Shoot[Timer] triggers a timeout signal
## [br][note] The minimum is always 0
@export var max_shooters_per_timeout: int = 2

#endregion

#region Public Vars
# TODO: Adicionar detector de parede dinamicamente que se ajusta sozinho
var wall_detector: Area2D

var regular_enemies_container: EnemyGroup
var lighting_shooters_container: EnemyGroup
var cross_shooters_container: EnemyGroup

var regular_enemies: Array[RegularEnemy]
var lighting_shooter_enemies: Array[ShooterEnemy]
var cross_shooter_enemies: Array[ShooterEnemy]
var all_shooter_enemies: Array[ShooterEnemy]

var move_speed: int = 10
var enemy_size = Vector2(36.0,24.0)

#endregion

#region Private Vars

#endregion


func _ready() -> void:
	if Engine.is_editor_hint():
		queue_redraw()
	if not Engine.is_editor_hint():
		wall_detector = %WallDetector
		regular_enemies_container = %RegularEnemies
		lighting_shooters_container = %LightningShooters
		cross_shooters_container = %CrossShooters
		
		# NOTE: Solução para problema de tipagem com for tipado sugerido pelo
		# Yann
		for child: RegularEnemy in regular_enemies_container.get_children():
			regular_enemies.append(child)
		for child: ShooterEnemy in lighting_shooters_container.get_children():
			lighting_shooter_enemies.append(child)
		for child: ShooterEnemy in cross_shooters_container.get_children():
			cross_shooter_enemies.append(child)

		all_shooter_enemies.append_array(cross_shooter_enemies)
		all_shooter_enemies.append_array(lighting_shooter_enemies)
		
		# TODO: Melhorar isso aqui para iterar os EnemyGroups em vez de separar 
		# por tipo, talvez?
		for enemy: Enemy in regular_enemies:
			enemy.died.connect(enemy_died.emit.bind(EnemyGroup.EnemyType.REGULAR))
		for enemy: ShooterEnemy in cross_shooter_enemies:
			enemy.died.connect(enemy_died.emit.bind(EnemyGroup.EnemyType.CROSS_SHOOTER))
		for enemy: ShooterEnemy in lighting_shooter_enemies:
			enemy.died.connect(enemy_died.emit.bind(EnemyGroup.EnemyType.LIGHTING_SHOOTER))
		
		_set_wall_detector_positions()

#region Public

#endregion

#region Private

func _get_random_shooter() -> ShooterEnemy:
	var random_shooter: ShooterEnemy = null
	var got_valid_random_shooter: bool = false
	while not got_valid_random_shooter:
		var random_index: int = randi_range(0, all_shooter_enemies.size()-1)
		# Foi necessário fazer dessa forma para evitar que fosse assignado um random shooter
		# inválido, que já não existe mais, no meio tempo entre pegar um inimigo aleatório do 
		# tipo shooter e assignar na variável random_shooter. (Sim, isso aconteceu 1x e crashou 
		# o jogo)
		if is_instance_valid(all_shooter_enemies.get(random_index)):
			random_shooter = all_shooter_enemies.get(random_index)
			got_valid_random_shooter = true
	return random_shooter


func _get_wall_detector_positions() -> Array[Vector2]:
	var left_most_position:Vector2 = Vector2.ZERO
	var right_most_position:Vector2 = Vector2.ZERO
	for enemy_group:EnemyGroup in $EnemyGroups.get_children():
		for enemy: Enemy in enemy_group.enemies:
			if enemy.position.x < left_most_position.x:
				left_most_position = enemy.position
			if enemy.position.x > right_most_position.x:
				right_most_position = enemy.position
	left_most_position.x -= enemy_size.x/2
	right_most_position.x += enemy_size.x/2
	return [left_most_position,right_most_position]


func _set_wall_detector_positions() -> void:
	var wall_detector_positions:Array[Vector2] = _get_wall_detector_positions()
	wall_detector.get_node("Left").position = wall_detector_positions[0]
	wall_detector.get_node("Right").position = wall_detector_positions[1]

#region Codigo nao usado

# Provavelmente o certo seria usar Transform2D aqui.
# Mas eu ainda não sei como usar isso 100%
# Acabei não usando isso, explicar para o Yann
func _get_swarm_total_area() -> Array[float]:
	# Pra calcular o wall detector dps Preciso pegar a posição do:
	# inimigo mais a esquerda e mais acima
	# inimigo mais a direita e mais em baixo
	# Com isso tenho um bounding box que pra achar o meio ponto
	# onde vou colocar o wall detector, basta eu fazer altura/2
	# e colocar os detectores na posição mais a esquerda e mais a direita
	# daquela altura com 
	# a esquerda: x_inicial - tamanho horizontal do inimigo/2
	# a direita: x_final + tamanho horizontal do inimigo/2
	var left_most_position:float = 0
	var right_most_position:float = 0
	var top_most_position: float = 0
	var bottom_most_position: float = 0
	for enemy_group:EnemyGroup in $EnemyGroups.get_children():
		for enemy: Enemy in enemy_group.enemies:
			if enemy.position.x < left_most_position:
				left_most_position = enemy.position.x
			if enemy.position.x > right_most_position:
				right_most_position = enemy.position.x
			if enemy.position.y < top_most_position:
				top_most_position = enemy.position.y
			if enemy.position.y > bottom_most_position:
				bottom_most_position = enemy.position.y
	return [left_most_position, right_most_position, top_most_position, bottom_most_position]

# Também não usei, mostrar para o Otavio
func _calculate_swarm_area() -> Vector2:
	#var total_enemies: int = regular_enemies.size() + lighting_shooters.size()
	# TODO: Tipa todas as variáveis
	#var enemy_total_area: Vector2 = enemy_size * total_enemies
	
	var _horizontal_gap: int = 24
	var _vertical_gap: int = 16
	var _enemies_per_line = 10
	
	# 36×10+(24×9) essa é a conta que tem que ser feita
	# 36 -> enemy size
	# 10 -> enemies per line
	# 24 -> h gap
	# 9 -> enemies per line - 1
	
	return Vector2(0.0, 0.0)
#endregion

#region Signal Callables


func _on_enemy_died(_enemy: Enemy, _enemy_type: EnemyGroup.EnemyType) -> void:
	_set_wall_detector_positions()


func _on_move_timer_timeout() -> void:
	position.x += move_speed


func _on_shoot_timer_timeout() -> void:
	for _index: int in randi_range(0,max_shooters_per_timeout):
		var enemy_to_shoot: ShooterEnemy = _get_random_shooter()
		if !enemy_to_shoot:
			return
		enemy_to_shoot.shoot()


func _on_wall_detector_body_entered(_wall: Node2D) -> void:
	#prints("hit wall:", wall)
	move_speed *= -1

#endregion
