class_name NonPlayerCharacter
extends KinematicBody

export var npc = "npc name"
export var dialog_index = 0

signal interacted(body)

func _ready():
	add_to_group("NPC")
	
func interact(body):
	emit_signal("interacted", body)

func start_dialog():
	var dialog = Dialogic.start(npc + str(dialog_index))
	GlobalSettings.set_disable_input("pause")
	dialog.pause_mode = PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_parent().add_child(dialog)
	dialog.connect("timeline_end", self, "end_dialog")
	get_tree().paused = true

func end_dialog(data):
	get_tree().paused = false
	GlobalSettings.set_disable_input(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
