@tool
@icon ("res://addons/at-icons/node2d/voxels.svg")
class_name EnemySwarm extends Node2D

# TODO: Evitar lambdas

#region Signal Declaration
signal enemy_died(enemy: Enemy, enemy_type: EnemyGroup.EnemyType)
#endregion

#region Public Vars
# TODO: Adicionar detector de parede dinamicamente que se ajusta sozinho
var wall_detector: Area2D

var move_timer: Timer
var shoot_timer: Timer

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
		wall_detector = $WallDetector
		move_timer = $MoveTimer
		shoot_timer = $ShootTimer
		move_timer.timeout.connect(_on_move_timer_timeout)
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)
		wall_detector.body_entered.connect(Callable(self, "_on_wall_hit"))
		
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
		
		for enemy: Enemy in regular_enemies:
			enemy.died.connect(enemy_died.emit.bind(EnemyGroup.EnemyType.REGULAR))
		for enemy: ShooterEnemy in cross_shooter_enemies:
			enemy.died.connect(enemy_died.emit.bind(EnemyGroup.EnemyType.CROSS_SHOOTER))
		for enemy: ShooterEnemy in lighting_shooter_enemies:
			enemy.died.connect(enemy_died.emit.bind(EnemyGroup.EnemyType.LIGHTING_SHOOTER))
	


#func calculate_swarm_area() -> Vector2:
	#var total_enemies: int = regular_enemies.size() + lighting_shooters.size()
	## TODO: Tipa todas as variáveis
	#var enemy_total_area: Vector2 = enemy_size * total_enemies
	#
	#var horizontal_gap: int = 24
	#var vertical_gap: int = 16
	#var enemies_per_line = 10
	#
	## 36×10+(24×9) essa é a conta que tem que ser feita
	## 36 -> enemy size
	## 10 -> enemies per line
	## 24 -> h gap
	## 9 -> enemies per line - 1
	#
	#return Vector2(0.0, 0.0)

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

#endregion

#region Signal Callables

func _on_move_timer_timeout() -> void:
	position.x += move_speed


func _on_shoot_timer_timeout() -> void:
	var enemy_to_shoot: ShooterEnemy = _get_random_shooter()
	if !enemy_to_shoot:
		return
	enemy_to_shoot.shoot()


func _on_wall_hit(_wall: Node2D) -> void:
	#prints("hit wall:", wall)
	move_speed *= -1

#endregion
