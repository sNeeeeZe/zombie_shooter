extends Area2D

var speed : int = 500
var direction : Vector2

func _process(delta) -> void:
	position += speed * direction * delta
