@icon ("res://addons/at-icons/node2d/voxels.svg")
class_name EnemySwarm extends Node2D

# Comentar sobre esse enemies com o Yann
@onready var enemies = get_enemies()
@onready var timer: Timer = $Timer
@onready var wallDetector: Area2D = $WallDetector

var moveSpeed: int = 10

func _ready() -> void:
	timer.timeout.connect(Callable(self, "onTick"))
	wallDetector.body_entered.connect(Callable(self, "onWallHit"))

func get_enemies() -> Array[RegularEnemy]:
	var nodeTypeComparator = func (node: Node): return node.is_class("Node2D")
	var nodes = get_children()
	return nodes.filter(nodeTypeComparator) as Array[RegularEnemy]

func onTick() -> void:
	print("tick")
	position.x += moveSpeed
	$LightningShooter.shoot()

func onWallHit(wall: Node2D) -> void:
	prints("hit wall:", wall)
	moveSpeed *= -1
	
