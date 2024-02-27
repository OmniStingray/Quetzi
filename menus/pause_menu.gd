class_name PauseMenu extends CanvasLayer

@onready var resume: Button = %Resume
@onready var restart: Button = %Restart


func _on_resume_pressed():
	queue_free()

func _process(delta: float):
	if Input.is_action_just_pressed("ui_cancel"):
		queue_free()

func _on_quit_pressed():
	get_tree().reload_current_scene()
	
func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false
