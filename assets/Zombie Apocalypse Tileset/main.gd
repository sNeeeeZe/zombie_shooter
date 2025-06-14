extends Node

var wave : int
var difficulty : float
const dif_multiplier : float = 1.2
var max_enemies : int
var lives : int

func _ready() -> void:
	new_game()
	$GameOver/Button.pressed.connect(new_game)
	
func new_game():
	wave = 1
	lives = 3
	difficulty = 10.0

	reset()

func reset():
	max_enemies = int(difficulty)
	$player.reset()
	get_tree().call_group("enemies","queue_free")
	get_tree().call_group("bullets","queue_free")
	get_tree().call_group("items","queue_free")
	
	$Hud/LivesLabel.text = "x " + str(lives)
	$Hud/WaveLabel.text = "WAVE : " + str(wave)
	$Hud/EnemiesLabel.text = "x " + str(max_enemies)
	$GameOver.hide()
	get_tree().paused = true
	$RestartTimer.start()

func _process(_delta) -> void:
	if is_wave_completed():
		wave += 1
		#adjust difficulty
		difficulty *= dif_multiplier
		get_tree().paused = true
		$WaveOverTimer.start()
		

func _on_wave_over_timer_timeout() -> void:
	reset()

func _on_enemyspawner_hit_p() -> void:
	lives -= 1
	$Hud/LivesLabel.text = "x " + str(lives)
	get_tree().paused = true
	if lives <= 0:
		$GameOver/WavesSurvivedLabel.text = "Wave Survived: " + str(wave - 1)
		$GameOver.show()
	else:
		$WaveOverTimer.start()


func _on_restart_timer_timeout() -> void:
	get_tree().paused = false

func is_wave_completed():
	var all_dead = true
	var enemies = get_tree().get_nodes_in_group("enemies")
	#check if all zombies are spawned
	if enemies.size() == max_enemies:
		for e in enemies:
			if e.alive:
				all_dead = false
		return all_dead
	else:
		return false
