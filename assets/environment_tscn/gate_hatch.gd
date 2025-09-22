extends Gate

onready var unlock_hatch = Dialogic.get_variable("unlock_hatch") 
onready var hatch_collision = $CollisionShapeHatch

func _ready():
	add_to_group("level_gate")

func start_level_request_dialog():
	var dialog = Dialogic.start(gate + str(dialog_index))
	dialog.pause_mode = PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_parent().add_child(dialog)
	dialog.connect("timeline_end",self, "end_dialog")
	get_tree().paused = true
	
func end_dialog(data):
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	



