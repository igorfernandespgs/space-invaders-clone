@icon ("res://addons/at-icons/node2d/ghost.svg")
class_name RegularEnemy extends Node2D

@onready var area = $Area2D

func die():
	print("%s died" % self.name)
	queue_free()
	Events.emit_signal("enemy_died", self)
