extends Area2D

@onready var main = get_node("/root/Main")
@onready var lives_label = get_node("/root/Main/Hud/LivesLabel")
var item_type : int #0 : coke, #1 : health, #2 : gun

var coke = preload("res://assets/Zombie Apocalypse Tileset/Organized separated sprites/Inventory interface/COKE_SLOT.png")
var health = preload("res://assets/Zombie Apocalypse Tileset/Organized separated sprites/Inventory interface/HEALTH_KIT_SLOT.png")
var gun = preload("res://assets/Zombie Apocalypse Tileset/Organized separated sprites/Inventory interface/TRIPLE_AMMO_SLOT.png")
var textures = [coke, health, gun]

func _ready() -> void:
	$Sprite2D.texture = textures[item_type]
	



func _on_body_entered(body: Node2D) -> void:
	#coke
	if item_type == 0:
		body.boost()
	#health
	elif item_type == 1:
		main.lives += 1
		lives_label.text = "x " + str(main.lives)
	#gun
	elif item_type == 2:
		body.quick_fire()
	queue_free()
