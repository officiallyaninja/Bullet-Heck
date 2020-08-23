extends RigidBody2D

signal destroyed

export var min_speed = 150
export var max_speed = 250
export(PackedScene) var TargetDestroyedEffect

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func disable_hitbox():
	$Area2D/CollisionShape2D.disabled = true

func _on_Area2D_area_entered(area):
	emit_signal("destroyed")
	var effect = TargetDestroyedEffect.instance()
	effect.position = self.global_position
	get_parent().add_child(effect)
	queue_free()
