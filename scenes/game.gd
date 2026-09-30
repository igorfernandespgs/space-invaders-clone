extends Node2D

func _ready() -> void:
	# TODO: Atualizar para Godot 4 usando o exemplo abaixo
	#Events.enemy_died.connect(Callable(self, "onEnemyDied"))
	Events.enemy_died.connect(onEnemyDied)

func onEnemyDied(enemy):
	print(enemy)
