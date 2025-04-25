extends Node2D

@onready var main = get_node("/root/Main")

signal hit_p

var zombie_scene := preload("res://assets/Zombie Apocalypse Tileset/zombie.tscn")
var spawn_points := []

func _ready() -> void:
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)

func _on_timer_timeout() -> void:
	#pick random spawn point
	var spawn = spawn_points[randi() % spawn_points.size()]
	#check how many enemies have already been created
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() < get_parent().max_enemies:
		#spawn enemy
		var zombie = zombie_scene.instantiate()
		zombie.position = spawn.position
		zombie.hit_player.connect(hit)
		main.add_child(zombie)
		zombie.add_to_group("enemies")

func hit():
	hit_p.emit()
