extends CanvasLayer

signal game_started
signal title_screen_shown

func _ready():
	$HighScoreMessage.hide()

func set_score(score):
	$ScoreLabel.text = str(score)



func _on_StartButton_pressed():
	emit_signal("game_started")
	$Title.hide()
	$StartButton.hide()
	$HighScoreMessage.hide()

func show_title_screen(high_score_achieved):
	$Title.show()
	$StartButton.show()
	if high_score_achieved:
		$HighScoreMessage.show()
	emit_signal("title_screen_shown")
