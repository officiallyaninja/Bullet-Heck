extends AnimatedSprite

func _ready():
	play()

func _on_PlayerDeathEffect_animation_finished():
	queue_free()
