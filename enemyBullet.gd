extends RigidBody2D

signal destroyed

export var min_speed = 200
export var max_speed = 300


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func disable_hitbox():
	$Area2D/CollisionShape2D.disabled = true
