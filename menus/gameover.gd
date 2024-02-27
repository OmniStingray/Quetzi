class_name GameOver extends CanvasLayer

@onready var score: Label = %ScoreLabel
@onready var high_score: Label = %HighScoreLabel
@onready var restart: Button = %RestartButton
@onready var quit: Button = %QuitButton

func set_score(n:int):
	score.text = "Final Score: " + str(n)
	if n > Global.save_data.high_score:
		high_score.visible = true
		Global.save_data.high_score = n
		Global.save_data.save()
	else:
		high_score.visible = false

func _on_restart_button_pressed():
	get_tree().reload_current_scene()  # will work for a simple game like this, but not for games with multiple scenes.

func _on_quit_button_pressed():
	get_tree().quit()  # won't work for a web browser game.

func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false
