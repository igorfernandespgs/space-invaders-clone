@icon ("res://addons/at-icons/node2d/dragon.svg")
class_name BossEnemy extends Enemy


@export var move_speed: int = 80

func _process(delta: float) -> void:
	position.x += move_speed * delta
