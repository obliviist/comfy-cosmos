extends Control

var is_paused = false setget set_is_paused

onready var settings_menu = $SettingsMenu

func _ready():
	pass

func _unhandled_input(event):
	
	if GlobalSettings.get_disabled_input():
		return
	
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_ResumeBtn_pressed():
	Sfx.stream = load("res://src/sfx/one_shots/Synth-Sinsad1.wav")
	Sfx.play()
	self.is_paused = false
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _on_SettingsBtn_pressed():
	Sfx.stream = load("res://src/sfx/one_shots/Synth-Sinsad2.wav")
	Sfx.play()
	settings_menu.popup_centered()

func _on_QuitBtn_pressed():
	get_tree().quit()
