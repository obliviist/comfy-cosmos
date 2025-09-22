extends NonPlayerCharacter

onready var cassette0 = $TapeDisplay/TapeZeroDisplay
onready var cassette1 = $TapeDisplay/TapeOneDisplay
onready var cassette2 = $TapeDisplay/TapeTwoDisplay
onready var cassette3 = $TapeDisplay/TapeThreeDisplay

func _ready():
	Dialogic.set_variable("radio_handler", 0)
	Music.stream = load("res://src/music/i_am_burrowing_loop.wav")
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
	if param == "stop":
		Music.stop()
	if param == "song0":
		Dialogic.set_variable("cp_track0", 0)
		Music.stop()
		Music.stream = load("res://src/music/i_am_burrowing_loop.wav")
		Music.play()
		cassette0.visible = true
		cassette1.visible = false
		cassette2.visible = false
		cassette3.visible = false
	if param == "song1":
		Dialogic.set_variable("cp_track1", 1)
		Music.stop()
		Music.stream = load("res://src/music/prancer_and_dancer_loop.wav")
		Music.play()
		cassette0.visible = false
		cassette1.visible = true
		cassette2.visible = false
		cassette3.visible = false
	if param == "song2":
		Dialogic.set_variable("cp_track2", 2)
		Music.stop()
		Music.stream = load("res://src/music/hot_cocoa_flow_loop.wav") #double check song
		Music.play()
		cassette0.visible = false
		cassette1.visible = false
		cassette2.visible = true
		cassette3.visible = false
	if param == "song3":
		Dialogic.set_variable("cp_track3", 3)
		Music.stop()
		Music.stream = load("res://src/music/chaos_and_mischief_loop.wav") 
		Music.play()
		cassette0.visible = false
		cassette1.visible = false
		cassette2.visible = false
		cassette3.visible = true
