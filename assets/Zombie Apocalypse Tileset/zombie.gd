extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/player")

var explosion_scene := preload("res://assets/Zombie Apocalypse Tileset/explosion.tscn")
var item_scene := preload("res://assets/Zombie Apocalypse Tileset/item.tscn")

signal hit_player 

var alive : bool
var entered : bool
var speed : int = 100
var direction : Vector2
const DROP_CHANCE : float = 0.1

func _ready() -> void:
	var screen_rect = get_viewport_rect()
	alive = true
	entered = false
	var dist = screen_rect.get_center() - position
	#check if they move horizontally or vertically
	if abs(dist.x) > abs(dist.y):
		#move horizontally
		direction.x = dist.x
		direction.y = 0
	else:
		direction.x = 0
		direction.y = dist.y
		
func _physics_process(_delta) -> void:
	if alive:
		$AnimatedSprite2D.animation = "walking"
		if entered:
			direction = (player.position - position)
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		pass
func die():
	alive = false
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	if randf() <= DROP_CHANCE:
		drop_item()
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	main.add_child(explosion)
	explosion.process_mode = Node.PROCESS_MODE_ALWAYS

func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0,2)
	main.call_deferred("add_child",item)
	item.add_to_group("items")

func _on_entrance_timer_timeout() -> void:
	entered = true
	
@warning_ignore("unused_parameter")
func _on_area_2d_body_entered(_body) -> void:
	hit_player.emit()
