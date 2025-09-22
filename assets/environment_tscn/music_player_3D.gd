extends NonPlayerCharacter

func _ready():
	Dialogic.set_variable("radio_handler", 2)
	Music.stream = load("res://src/music/spiders and cows_loop.wav")
	Music.play()
	add_to_group("NPC")
	
func interact(body):
	emit_signal("interacted", body)

func start_dialog():
	var dialog = Dialogic.start(npc + str(dialog_index))
	dialog.pause_mode = PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_parent().add_child(dialog)
	dialog.connect("timeline_end", self, "end_dialog")
	dialog.connect("dialogic_signal", self, "dialogic_signal_event")
	get_tree().paused = true
	
func end_dialog(data):
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func dialogic_signal_event(param):
	if param == "song0":
		Dialogic.set_variable("radio_handler", 0)
		Music.stop()
		Music.stream = load("")
		Music.play()
	if param == "song1":
		Dialogic.set_variable("radio_handler", 1)
		Music.stop()
		Music.stream = load("")
		Music.play()
	if param == "song2":
		Dialogic.set_variable("radio_handler", 2)
		Music.stop()
		Music.stream = load("")
		Music.play()
		
