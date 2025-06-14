extends Area2D

var speed : int = 500
var direction : Vector2

func _process(delta) -> void:
	position += speed * direction * delta


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "world":
		queue_free()
	else:
		if body.alive:
			body.die()
			queue_free()
