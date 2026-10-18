@icon ("res://addons/at-icons/node2d/skull_and_crossbones.svg")
class_name ShooterEnemy extends Enemy

@export_group("Projectile")
@export var bullet_configuration: BulletConfiguration

var bullet_instance: Bullet

var bullet_origin: Marker2D
var map:Node2D 

func _ready() -> void:
	bullet_origin = $BulletOrigin
	map = get_tree().get_nodes_in_group("map")[0]

func shoot() -> void:
	if bullet_instance:
		return
	bullet_instance = bullet_configuration.bullet_scene.instantiate()
	map.add_child(bullet_instance)
	bullet_instance.position = bullet_origin.global_position
	bullet_instance.bullet_configuration = bullet_configuration
	#bullet_instance.bullet_configuration.bullet_speed *= -1
	bullet_instance.collision_area.body_entered.connect(_on_projectile_hit_wall)
	bullet_instance.collision_area.area_entered.connect(_on_projectile_hit_entity)


func _on_projectile_hit_wall(_wall: Node2D):
	#prints("%s bullet hit wall: %s" % [self.name, wall])
	bullet_instance.queue_free()


func _on_projectile_hit_entity(entity_area: Area2D):
	if entity_area.owner is not Player:
		return
	var player: Player = entity_area.owner
	prints("hit player")
	bullet_instance.queue_free()
	player.die()
