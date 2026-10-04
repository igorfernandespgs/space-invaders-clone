@icon ("res://addons/at-icons/node2d/skull_and_crossbones.svg")
class_name ShooterEnemy extends Enemy

@export_group("Projectile")
@export var bullet_scene: PackedScene = preload("res://scenes/entities/bullet.tscn")
@export var bullet_speed: int = 300

var bullet_instance: Bullet

@onready var bullet_origin: Marker2D = $BulletOrigin
@onready var map:Node2D = get_tree().get_nodes_in_group("map")[0]


func shoot() -> void:
	if bullet_instance:
		return
	print("%s Atirando!" % self.name)
	bullet_instance = bullet_scene.instantiate()
	map.add_child(bullet_instance)
	bullet_instance.speed = bullet_speed * -1
	bullet_instance.position = bullet_origin.global_position
	bullet_instance.collision_area.body_entered.connect(_on_projectile_hit_wall)
	bullet_instance.collision_area.area_entered.connect(_on_projectile_hit_entity)


func _on_projectile_hit_wall(wall: Node2D):
	prints("%s bullet hit wall: %s" % [self.name, wall])
	bullet_instance.queue_free()


func _on_projectile_hit_entity(entity_area: Area2D):
	if entity_area.owner is not Player:
		return
	var player: Player = entity_area.owner
	prints("hit player")
	bullet_instance.queue_free()
	player.die()
