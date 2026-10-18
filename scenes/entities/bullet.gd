@tool
@icon("res://addons/at-icons/node2d/bullet.svg")
class_name Bullet extends Node2D

const bulletTypeSprite: Dictionary[BulletConfiguration.BulletType, String] = {
	BulletConfiguration.BulletType.NORMAL: "NormalBullet",
	BulletConfiguration.BulletType.LIGHTNING: "LightningBullet",
	BulletConfiguration.BulletType.CROSS: "CrossBullet"
}

const bulletTypeCollision: Dictionary[BulletConfiguration.BulletType, String] = {
	BulletConfiguration.BulletType.NORMAL: "NormalCollisionShape",
	BulletConfiguration.BulletType.LIGHTNING: "ShooterCollisionShape",
	BulletConfiguration.BulletType.CROSS: "ShooterCollisionShape"
}

@export var bullet_configuration:BulletConfiguration:
	set(new_bullet_configuration):
		if bullet_configuration:
			if bullet_configuration.changed.is_connected(_on_configuration_changed):
				bullet_configuration.changed.disconnect(_on_configuration_changed)
		bullet_configuration = new_bullet_configuration
		if bullet_configuration:
			bullet_configuration.changed.connect(_on_configuration_changed)
		_update_bullet_visual()
		_update_collision()

var collision_area: Area2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	collision_area = $Area
	_update_bullet_visual()
	_update_collision()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var speed = bullet_configuration.bullet_speed
	position.y -= speed * delta


func _exit_tree() -> void:
	if Engine.is_editor_hint():
		if bullet_configuration.changed.is_connected(_on_configuration_changed):
			bullet_configuration.changed.disconnect(_on_configuration_changed)


func _update_bullet_visual() -> void:
	if not bullet_configuration:
		return
	var bullet_visual_name = bulletTypeSprite.get(bullet_configuration.bullet_type)
	if not get_node_or_null("Visuals"):
		return
	for visual_node: Node2D in $Visuals.get_children():
		visual_node.visible = false
	var visual: Node2D = $Visuals.get_node(bullet_visual_name)
	visual.visible = true
	#prints("bullet visual update:",bullet_visual_name)
	if Engine.is_editor_hint():
		if visual is AnimatedSprite2D:
			visual.play()


func _update_collision() -> void:
	if not bullet_configuration:
		return
	var collision_name = bulletTypeCollision.get(bullet_configuration.bullet_type)
	if not get_node_or_null("Area"):
		return
	for collision_shape: CollisionShape2D in $Area.get_children():
		collision_shape.visible = false
		collision_shape.disabled = true
	var collision_shape: CollisionShape2D = $Area.get_node(collision_name)
	collision_shape.visible = true
	collision_shape.disabled = false


func _on_configuration_changed() -> void:
	_update_bullet_visual()
	_update_collision()
