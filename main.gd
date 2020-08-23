extends Node2D

export var time : int
export(PackedScene) var Bullet
export(PackedScene) var Target
export(PackedScene) var EnemyBullet
export(PackedScene) var PlayerDeathEffect
export(PackedScene) var TimeOutEffect

var targets_destroyed = 0
var score = 0 setget set_score
var high_score : int = 420000
var time_left : int setget set_time_left
var high_score_achieved: bool

func set_score(value):
	if $Player.dead:
		return
	score = value
	$HUD.set_score(score)

func set_time_left(value):
	time_left = value
	$HUD/TimerLabel.text = str(time_left)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$MenuMusic.play()
		
func _on_Music_finished():
	if $MenuMusic.playing:
		return
	$Music.play()


func _on_Player_fired_gun():
	var bullet =  Bullet.instance()
	var bullet_pos = $Player/Gun/BulletSpawnPoint.global_position
	var bullet_vel = (get_global_mouse_position() - bullet_pos).normalized()
	add_child(bullet)
	bullet.fire(bullet_pos,bullet_vel)


func _on_SpawnTargetTimer_timeout():
	$TargetPath/TargetSpawnPoint.offset = randi()
	var target = Target.instance()
	add_child(target)
	
	target.connect('destroyed', self, 'On_Target_Destroyed')

	# direction is an angle here
	var direction = $TargetPath/TargetSpawnPoint.rotation + PI/2
	direction += rand_range(-PI/4,PI/4)
	
	target.position = $TargetPath/TargetSpawnPoint.position
	
	target.linear_velocity = Vector2(rand_range(target.min_speed, target.max_speed),0)
	target.linear_velocity = target.linear_velocity.rotated(direction)



func _on_SpawnEnemyBulletTimer_timeout():
	$TargetPath/TargetSpawnPoint.offset = randi()
	var enemy_bullet = EnemyBullet.instance()
	add_child(enemy_bullet)
	var direction = $TargetPath/TargetSpawnPoint.rotation + PI/2
	direction += rand_range(-PI/4,PI/4)
	
	enemy_bullet.position = $TargetPath/TargetSpawnPoint.position
	enemy_bullet.rotation = direction
	
	enemy_bullet.linear_velocity = Vector2(rand_range(enemy_bullet.min_speed, enemy_bullet.max_speed),0)
	enemy_bullet.linear_velocity = enemy_bullet.linear_velocity.rotated(direction)

func _on_ScoreTimer_timeout():
	set_score(score + 100*(targets_destroyed+1))
	

func On_Target_Destroyed():	
	set_score(score + 500)
	#$HUD.set_score(score)
	targets_destroyed += 1
	if targets_destroyed % 1 == 0:
		if $SpawnTargetTimer.wait_time > 0.5:
			$SpawnTargetTimer.wait_time *= 0.9
		$SpawnEnemyBulletTimer.wait_time *= 0.9
		
	
	$TargetHitSound.play()


func start_game():
	$HUD/GameOverText.hide()
	$HUD/TimerLabel.set('custom_colors/font_color',Color(0,1,0))
	
	$MenuMusic.stop()
	$Music.play()
	
	get_tree().call_group("targets", "queue_free")
	get_tree().call_group("enemy_bullets", "queue_free")
	
	$Player.start(Vector2(230,180))
	$ScoreTimer.start()
	$GameTimer.start()

	$SpawnEnemyBulletTimer.start()
	$SpawnEnemyBulletTimer.wait_time = 1
	
	$SpawnTargetTimer.start()
	$SpawnTargetTimer.wait_time = 1
	
	self.score = 0
	targets_destroyed = 0
	self.time_left = time

func _on_Player_died():
	$HUD/GameOverText.text = "YOU DIED"
	var effect = PlayerDeathEffect.instance()
	effect.position = $Player.position
	add_child(effect)
	
	game_over()

func _on_GameTimer_timeout():
	self.time_left -= 1
	
	if time_left == 5:
		$HUD/TimerLabel.set('custom_colors/font_color',Color(1,0,0))
	
	if time_left == 0:
		$HUD/GameOverText.text = 'TIME OUT'

		var effect = TimeOutEffect.instance()
		effect.position = $Player.position
		add_child(effect)

		$TimeOutSound.play()
		game_over()

func game_over():
	$HUD/GameOverText.show()
	$Player.game_over()
	if score > high_score:
		high_score = score
		high_score_achieved = true
	else:
		high_score_achieved = false
	score = 0
	$ScoreTimer.stop()
	get_tree().call_group("targets", "disable_hitbox")
	get_tree().call_group("enemy_bullets", "disable_hitbox")
	$SpawnEnemyBulletTimer.stop()
	$SpawnTargetTimer.stop()
	$GameTimer.stop()
	$HUD/HighScoreLabel.text = str(high_score)
	
	$TitleScreenTimer.start()


func _on_TitleScreenTimer_timeout():
	self.score = 0
	$HUD.show_title_screen(high_score_achieved)


func _on_HUD_title_screen_shown():
	$Music.stop()
	$MenuMusic.play()




