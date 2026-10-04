@icon("res://addons/at-icons/node2d/bullet.svg")
class_name Bullet extends Node2D

var speed: int = 10
@onready var collision_area: Area2D = $Area

func _process(delta: float) -> void:
	position.y -= speed * delta
