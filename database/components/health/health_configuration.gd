@tool
@icon ("res://addons/at-icons/node2d/heart.svg")
class_name HealthConfiguration extends Resource

### Vou usar esse sinal para conectar com a UI que ainda não existe
signal health_changed(current_hp: int)

#region Export Variables

@export_group("Configuration")

@export var max_hp: int = 8:
	set(new_max_hp):
		if new_max_hp < 1:
			print("The Maximum HP needs to be at least 1")
			return
		max_hp = new_max_hp
		# Só por precaução pra evitar existir alguma config que eu faça
		# em que o HP máximo possa ser menor do que o HP inicial
		if max_hp < start_hp:
			start_hp = max_hp

@export var start_hp: int = 3:
	set(new_start_hp):
		if new_start_hp > max_hp:
			print("The starting HP can't be bigger than the Max HP")
			return
		if new_start_hp < 1:
			print("The starting HP needs to be at least 1")
			return
		start_hp = new_start_hp

#endregion

#region Public Variablesss

var current_hp: int = 0

#endregion


func _init() -> void:
	if Engine.is_editor_hint():
		return
	current_hp = start_hp


# NOTE: Ainda não estou usando, mas vai ser usado para quando o player
# eliminar todos os inimigos do EnemySwarm
func add_to_current_hp(amount: int) -> bool:
	if current_hp + amount > max_hp:
		return false
	current_hp += amount
	health_changed.emit(current_hp)
	return true


func remove_from_current_hp(amount: int) -> void:
	current_hp -= amount
	health_changed.emit(current_hp)
