@icon ("res://addons/at-icons/node2d/voxels.svg")
class_name EnemySwarm extends Node2D

@onready var enemies = self.get_children().filter(func (node: Node): return node.is_class("Node2D"))
@onready var timer = $Timer
@onready var wallDetector = $WallDetector

var moveFactor: int = 10

func _ready() -> void:
	timer.timeout.connect(Callable(self, "onTick"))
	
	wallDetector.body_entered.connect(Callable(self, "onWallHit"))

func onTick() -> void:
	print("tick")
	position.x += moveFactor

func onWallHit(wall: Node2D) -> void:
	prints("hit wall:", wall)
	moveFactor *= -1
	
