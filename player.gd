extends Node2D

@export var leftCornerNode: Marker2D
@export var rightCornerNode: Marker2D
@export var bulletScene: PackedScene

var leftCornerLimit: int
var rightCornerLimit: int
var bulletInstance: Bullet

@onready var playerSpriteSize: int = $Sprite2D.get_rect().size.x


func _ready() -> void:
	leftCornerLimit = int(leftCornerNode.position.x) + playerSpriteSize * 2
	rightCornerLimit = int(rightCornerNode.position.x) - playerSpriteSize * 2
	printt(leftCornerLimit, rightCornerLimit)


func _process(_delta: float) -> void:
	if (Input.is_action_pressed("move_left")):
		if (position.x > leftCornerLimit):
			position.x -= 10
	elif (Input.is_action_pressed("move_right")):
		if (position.x < rightCornerLimit):
			position.x += 10
	if (Input.is_action_pressed("shoot")):
		print("atirando!")
