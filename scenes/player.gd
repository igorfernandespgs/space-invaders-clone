@icon("res://addons/at-icons/node2d/human.svg")
class_name Player extends Node2D

@export_group("World Bounds")
@export var leftCornerNode: Marker2D
@export var rightCornerNode: Marker2D

@export_group("Projectile")
@export var bulletScene: PackedScene = preload("res://scenes/bullet.tscn")
@export var bulletSpeed: int

@export_group("Stats")
@export var moveSpeed:int = 5

var leftCornerLimit: int
var rightCornerLimit: int
var bulletInstance: Bullet

@onready var playerSpriteSize: int = $Sprite2D.get_rect().size.x
@onready var bulletOrigin: Marker2D = $BulletOrigin
@onready var playground:Node2D = get_parent()


func _ready() -> void:
	leftCornerLimit = int(leftCornerNode.position.x) + playerSpriteSize * 2 
	rightCornerLimit = int(rightCornerNode.position.x) - playerSpriteSize * 2


func _process(delta: float) -> void:
	if (Input.is_action_pressed("move_left")):
		move_left(delta * moveSpeed)
	elif (Input.is_action_pressed("move_right")):
		move_right(delta * moveSpeed)
	if (Input.is_action_pressed("shoot")):
		shoot()


func move_left(amount: float) -> void:
	if (position.x > leftCornerLimit): 
		position.x -= amount


func move_right(amount: float) -> void:
	if (position.x < rightCornerLimit):
		position.x += amount


func shoot() -> void:
	if bulletInstance:
		return
	print("Atirando!")
	bulletInstance = bulletScene.instantiate()
	playground.add_child(bulletInstance) 
	bulletInstance.speed = bulletSpeed
	bulletInstance.position = bulletOrigin.global_position
	
	await get_tree().create_timer(1.0).timeout
	bulletInstance.queue_free()
	print("Excluindo o projétil...")
