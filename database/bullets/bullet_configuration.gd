@tool
@icon ("res://addons/at-icons/node2d/cog.svg")
class_name BulletConfiguration extends Resource

enum BulletType { NORMAL, CROSS, LIGHTNING }

@export var bullet_scene: PackedScene = preload("res://scenes/entities/bullet.tscn")
@export var bullet_type: BulletType = BulletType.NORMAL:
	set(new_bullet_type):
		bullet_type = new_bullet_type
		emit_changed()
		
@export var bullet_speed: int = 300
