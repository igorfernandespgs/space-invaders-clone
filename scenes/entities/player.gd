@icon("res://addons/at-icons/node2d/human.svg")
class_name Player extends Node2D
# NOTE: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order

@export_group("World Bounds")
@export var left_corner_node: Marker2D
@export var right_corner_node: Marker2D

@export_group("Projectile")
@export var bullet_scene: PackedScene = preload("res://scenes/entities/bullet.tscn")
@export var bullet_speed: int = 300

@export_group("Stats")
@export var move_speed:int = 150

var bullet_origin: Marker2D
var map:Node2D

var player_border_margin: int = 26
var left_corner_limit: int
var right_corner_limit: int
var bullet_instance: Bullet

func _ready() -> void:
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
	if (position.x < right_corner_limit):
		position.x += amount


func shoot() -> void:
	if bullet_instance:
		return
	#print("Atirando!")
	bullet_instance = bullet_scene.instantiate()
	map.add_child(bullet_instance) 
	bullet_instance.speed = bullet_speed
	bullet_instance.position = bullet_origin.global_position
	bullet_instance.collision_area.body_entered.connect(_on_projectile_hit_walll)
	bullet_instance.collision_area.area_entered.connect(_on_projectile_hit_enemy)


func die():
	print("player died")


func _on_projectile_hit_walll(_wall: Node2D):
	#prints("hit wall:", wall)
	bullet_instance.queue_free()


func _on_projectile_hit_enemy(enemyArea: Area2D):
	#prints("hit enemy:", enemyArea.get_parent().name)
	bullet_instance.queue_free()
	if enemyArea.owner is Enemy:
		var enemy: Enemy = enemyArea.owner
		enemy.die()
