extends Gate

onready var wall_anim = get_node("cellar_wall/CellarWallAnimationPlayer")

func _ready():
	add_to_group("level_gate")

func start_level_request_dialog():
	var dialog = Dialogic.start(gate + str(dialog_index))
	dialog.pause_mode = PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_parent().add_child(dialog)
	dialog.connect("timeline_end",self, "end_dialog")
	dialog.connect("dialogic_signal", self, "dialogic_signal_event")
	get_tree().paused = true
	
func end_dialog(data):
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func dialogic_signal_event(param):
	if param == "wall_fall":
		wall_anim.play("cellar_wall_fall")
		$CollisionShapeWall1.disabled = true
		$CollisionShapeWall2.disabled = true
