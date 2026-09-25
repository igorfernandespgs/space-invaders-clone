@icon("icon.svg")
class_name Bullet extends Node2D

@export var speed: int = 2

func _process(delta: float) -> void:
	position.y -= speed * delta
