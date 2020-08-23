extends RigidBody2D

signal hit_target

export var SPEED = 100

func fire(pos, vel):
	$GunSound.play()
	position = pos
	linear_velocity = vel*SPEED
	rotation = vel.angle()


func _on_GunHitbox_area_entered(area):
	emit_signal("hit_target")
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
