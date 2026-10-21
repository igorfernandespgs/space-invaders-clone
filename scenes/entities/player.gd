@icon("res://addons/at-icons/node2d/human.svg")
class_name Player extends Node2D
# NOTE: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order

# TODO: Pegar o tamanho da tela pela API do Godot
# TODO: Fazer a bala ser mais autônoma

# TODO: Reaproveitar o signal tree_exited
signal died(life_left: int)

@export_group("World Bounds")
@export var left_corner_node: Marker2D
@export var right_corner_node: Marker2D

@export_group("Projectile")
@export var bullet_configuration: BulletConfiguration

@export_group("Stats")
@export var move_speed:int = 150
@export var health_configuration: HealthConfiguration

var bullet_origin: Marker2D
var map:Node2D

# TODO: O que fazer cm isso aqui?
var player_border_margin: int = 26
var left_corner_limit: int
var right_corner_limit: int
var bullet_instance: Bullet


func _ready() -> void:
	# TODO: Magic number
	left_corner_limit = player_border_margin
	right_corner_limit = 1152 - player_border_margin
	bullet_origin = $BulletOrigin
	map = get_parent()


func _process(delta: float) -> void:
	if (Input.is_action_pressed("move_left")):
		move_left(delta * move_speed)
	elif (Input.is_action_pressed("move_right")):
		move_right(delta * move_speed)
	if (Input.is_action_pressed("shoot")):
		shoot()


func move_left(amount: float) -> void:
	if (position.x > left_corner_limit): 
		position.x -= amount


func move_right(amount: float) -> void:
	# TODO: Não precisa de parentese em if
	if (position.x < right_corner_limit):
		position.x += amount


func shoot() -> void:
	if bullet_instance:
		return
	bullet_instance = bullet_configuration.bullet_scene.instantiate()
	map.add_child(bullet_instance)
	bullet_instance.bullet_configuration = bullet_configuration
	bullet_instance.position = bullet_origin.global_position
	bullet_instance.collision_area.body_entered.connect(_on_projectile_hit_walll)
	bullet_instance.collision_area.area_entered.connect(_on_projectile_hit_enemy)


func die():
	# TODO: Ver como o player vai ser destruído/respawnar antes de continuar 
	print("player died")
	health_configuration.remove_from_current_hp(1)
	prints("current health:",health_configuration.current_hp)
	died.emit(health_configuration.current_hp)

# TODO: Walll (typo)
func _on_projectile_hit_walll(_wall: Node2D):
	#prints("hit wall:", wall)
	bullet_instance.queue_free()


func _on_projectile_hit_enemy(enemyArea: Area2D):
	#prints("hit enemy:", enemyArea.get_parent().name)
	bullet_instance.queue_free()
	if enemyArea.owner is Enemy:
		var enemy: Enemy = enemyArea.owner
		enemy.die()
