extends AnimatedSprite

func _on_TargetDestroyedEffect_animation_finished():
	queue_free()
