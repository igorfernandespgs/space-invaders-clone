@icon("res://addons/at-icons/node2d/bullet.svg")
class_name Bullet extends Node2D

# Perguntar sobre sub classe aqui

enum BulletType { NORMAL, CROSS, LIGHTNING }

var speed_variation: int = 0

@export var bullet_type: BulletType = BulletType.NORMAL:
	set(new_bullet_type):
		bullet_type = new_bullet_type
		if new_bullet_type == BulletType.LIGHTNING:
			speed_variation = speed * 2
		else:
			speed_variation = 0

var collision_area: Area2D
var speed: int = 10


func _ready() -> void:
	collision_area = $Area
	if bullet_type == BulletType.LIGHTNING:
		$InvertSpriteTimer.timeout.connect(_on_invert_sprite_timer_timeout)


func _process(delta: float) -> void:
	position.y -= (speed + speed_variation) * delta


func _on_invert_sprite_timer_timeout() -> void:
	$Sprite2D.flip_h = !$Sprite2D.flip_h
