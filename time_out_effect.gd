extends AnimatedSprite

func _ready():
	play()

func _on_TimeOutEffect_animation_finished():
	queue_free()
