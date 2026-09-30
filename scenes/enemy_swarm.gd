@icon ("res://addons/at-icons/node2d/voxels.svg")
class_name EnemySwarm extends Node2D

# Comentar sobre esse enemies com o Yann
@onready var regularEnemies: Array = $RegularEnemies.get_children()
@onready var lightingShooters: Array = $LightingShooters.get_children()
@onready var timer: Timer = $Timer
@onready var wallDetector: Area2D = $WallDetector

var moveSpeed: int = 10


func _ready() -> void:
	timer.timeout.connect(Callable(self, "onTick"))
	wallDetector.body_entered.connect(Callable(self, "onWallHit"))


func onTick() -> void:
	position.x += moveSpeed
	if lightingShooters.any(func (node): return is_instance_valid(node)):		
		var enemyToShoot: ShooterEnemy = getRandomEnemyToShoot()
		if !enemyToShoot:
			return
		enemyToShoot.shoot()
	else:
		print("No enemies left")

func getRandomEnemyToShoot() -> ShooterEnemy:
	var randomIndex: int = randi_range(0, lightingShooters.size()-1)
	return lightingShooters.get(randomIndex) if is_instance_valid(lightingShooters.get(randomIndex)) else getRandomEnemyToShoot()

func onWallHit(wall: Node2D) -> void:
	prints("hit wall:", wall)
	moveSpeed *= -1
	
