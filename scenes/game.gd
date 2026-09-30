extends Node2D

func _ready() -> void:
	Events.enemy_died.connect(Callable(self, "onEnemyDied"))


func onEnemyDied(enemy):
	print(enemy)
