extends KinematicBody2D


export var SPEED = 400 
export var DASH_MULTIPLIER = 5
var dashing = false 
var velocity = Vector2.ZERO
var screen_size
var dead = true

signal fired_gun
signal died

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func dash():
	dashing = true
	$DashTimer.start()


func _physics_process(delta):
	if dead:
		return
	
	position.x = clamp(position.x,0,screen_size.x)
	position.y = clamp(position.y,0,screen_size.y)
	
	var mouse_pos = get_global_mouse_position()
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		
	if Input.is_action_just_pressed("dash") and $DashCooldown.time_left == 0 and velocity.length() > 0:
		print('ddsf')
		$DashSound.play()
		$DashCooldown.start()
		dash()


	if dashing:
		velocity *= DASH_MULTIPLIER
		
	if velocity.length() > 0:
		$Model/Legs.play()
	else:
		$Model/Legs.stop()
		$Model/Legs.frame = 0
	move_and_slide(velocity*SPEED*delta*60)

	var facing_direction = (mouse_pos - global_position).normalized()
	rotation = (facing_direction).angle()

	var gun_facing_direction = (mouse_pos - $Gun/GunSprite.global_position).normalized()
	$Gun/GunSprite.rotation = facing_direction.angle_to(gun_facing_direction)
	
	if Input.is_action_just_pressed("shoot") and $Gun/Timer.time_left == 0:
		$Gun/Timer.start()
		emit_signal("fired_gun")


func _on_DashCooldown_timeout():
	if not dead:
		$DashReadySound.play()

func _on_DashTimer_timeout():
	dashing = false

func start(pos):
	show()
	position = pos
	$Hitbox/CollisionShape2D.disabled = false
	dead = false
	

func _on_Hitbox_area_entered(area):
	if dead:
		return
	emit_signal('died')
	$DeathSound.play()
	
func game_over():
	hide()
	$Hitbox/CollisionShape2D.disabled = true
	dead = true
	$DashCooldown.stop()

