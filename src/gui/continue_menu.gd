extends Control

onready var scene_tree: SceneTree = get_tree()
onready var settings_menu = $SettingsMenu

func _ready():
	GlobalSettings.connect("updated", self, "update_interface")
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _on_ContinueBtn_pressed():
	get_tree().change_scene("res://save_slots/save_continue.tscn")
	Music.stop()
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
func _on_MenuBtn_pressed():
	get_tree().change_scene("res://src/gui/start_screen.tscn") 
	Music.stop()
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_SettingsBtn_pressed():
	settings_menu.popup_centered()


func _on_QuitBtn_pressed():
	get_tree().quit()
