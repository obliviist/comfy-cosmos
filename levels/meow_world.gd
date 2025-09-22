extends Spatial

onready var world_env = $Environment/WorldEnvironment

func _ready():
	Music.stop()
	Amb.stream = load("res://src/sfx/amb_loops/wind1.wav")
	Amb.play()
	
	var new_dialog = Dialogic.start('ending0')
	new_dialog.connect("dialogic_signal", self, "dialog_listener")
	add_child(new_dialog)
	new_dialog.connect("timeline_end", self, "end_dialog")


func end_dialog():
	get_tree().paused = false
	GlobalSettings.set_disable_input(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

