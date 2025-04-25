extends CharacterBody2D

var speed : int
var screen_size : Vector2
signal shoot

func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	speed = 200

func get_input():
	#keyboard input
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed
	
	#mouse clicks
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)

func _physics_process(_delta) -> void:
	get_input()
	move_and_slide()
	
	#limit movement to the size of the screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#player rotation
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI / 2) / (PI / 2)
	angle = wrapi(int(angle), 0, 4)

	$AnimatedSprite2D.animation = "walk" + str(angle)
	
	#player animation
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else :
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1
