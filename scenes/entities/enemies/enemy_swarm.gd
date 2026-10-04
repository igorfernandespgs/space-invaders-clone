@icon ("res://addons/at-icons/node2d/voxels.svg")
class_name EnemySwarm extends Node2D

@onready var regular_enemies: Array = $RegularEnemies.get_children()
@onready var lighting_shooters: Array = $LightingShooters.get_children()
@onready var timer: Timer = $Timer
@onready var wall_detector: Area2D = $WallDetector

var move_speed: int = 10
var enemy_size = Vector2(36.0,24.0)


func _ready() -> void:
	timer.timeout.connect(Callable(self, "_on_tick"))
	wall_detector.body_entered.connect(Callable(self, "_on_wall_hit"))


func calculate_swarm_area() -> Vector2:
	var total_enemies: int = regular_enemies.size() + lighting_shooters.size()
	var enemy_total_area = enemy_size * total_enemies
	
	var horizontal_gap: int = 24
	var vertical_gap: int = 16
	var enemies_per_line = 10
	
	# 36×10+(24×9) essa é a conta que tem que ser feita
	
	return Vector2(0.0, 0.0) 

func get_random_shooter() -> ShooterEnemy:
	var random_index: int = randi_range(0, lighting_shooters.size()-1)
	return lighting_shooters.get(random_index) if is_instance_valid(lighting_shooters.get(random_index)) else get_random_shooter()


func _on_tick() -> void:
	position.x += move_speed
	if lighting_shooters.any(func (node): return is_instance_valid(node)):
		var enemy_to_shoot: ShooterEnemy = get_random_shooter()
		if !enemy_to_shoot:
			return
		enemy_to_shoot.shoot()
	else:
		print("No enemies left")


func _on_wall_hit(wall: Node2D) -> void:
	prints("hit wall:", wall)
	move_speed *= -1
	
