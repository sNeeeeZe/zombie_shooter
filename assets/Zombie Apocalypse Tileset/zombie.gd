extends CharacterBody2D

@onready var player = get_node("/root/Main/player")

signal hit_player 

var entered : bool
var speed : int = 100
var direction : Vector2

func _ready() -> void:
	var screen_rect = get_viewport_rect()
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
	$AnimatedSprite2D.animation = "walking"
	if entered:
		direction = (player.position - position)
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	

func _on_entrance_timer_timeout() -> void:
	entered = true
	
@warning_ignore("unused_parameter")
func _on_area_2d_body_entered(_body) -> void:
	hit_player.emit()
