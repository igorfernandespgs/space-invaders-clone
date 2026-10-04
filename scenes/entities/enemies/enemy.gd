@icon ("res://addons/at-icons/node2d/skull.svg")
class_name Enemy extends Node2D

signal died(entity: Enemy)

func die():
	print("%s died" % self.name)
	died.emit(self)
	queue_free()
