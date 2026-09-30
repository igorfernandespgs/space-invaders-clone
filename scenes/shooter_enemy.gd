@icon ("res://addons/at-icons/node2d/skull.svg")
class_name ShooterEnemy extends Node2D

@export_group("Projectile")
@export var bulletScene: PackedScene = preload("res://scenes/bullet.tscn")
@export var bulletSpeed: int = 300

var bulletInstance: Bullet

@onready var bulletOrigin: Marker2D = $BulletOrigin
@onready var playground:Node2D = get_tree().get_nodes_in_group("map")[0]


func shoot() -> void:
	if bulletInstance:
		return
	print("%s Atirando!" % self.name)
	bulletInstance = bulletScene.instantiate()
	playground.add_child(bulletInstance) 
	bulletInstance.speed = bulletSpeed * -1
	bulletInstance.position = bulletOrigin.global_position
	bulletInstance.collisionArea.body_entered.connect(Callable(self, "onProjectileHitWall"))
	bulletInstance.collisionArea.area_entered.connect(Callable(self, "onProjectileHitPlayer"))


func die():
	print("%s died" % self.name)
	Events.emit_signal("enemy_died", self)
	queue_free()


func onProjectileHitWall(wall: Node2D):
	prints("%s bullet hit wall: %s" % [self.name, wall])
	bulletInstance.queue_free()


func onProjectileHitPlayer(entityArea: Area2D):
	
	# TODO: Resolver isso aqui usando owner e a keyword "is" para 
	# fazer uma condicional e já castar a variável para o tipo Player
	var isPlayer = entityArea.get_parent().name.match("Player")
	
	if not isPlayer:
		return
	var player: Player = entityArea.get_parent()
	prints("hit player")
	bulletInstance.queue_free()
	player.die()
