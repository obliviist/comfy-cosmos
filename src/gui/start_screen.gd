extends CanvasLayer

export(String, FILE) var level

onready var start_btn = $MainMenu/MarginContainer/VBoxContainer/StartBtn
onready var howtoplay_menu = $HowToPlayPopup
onready var controls_menu = $ControlsPopup
onready var settings_menu = $SettingsMenu

func _ready():
	get_tree().paused = false
	start_btn.grab_focus()
	Music.stream = load("res://src/music/i_am_burrowing_loop.wav") 
	Music.play()

func _on_StartBtn_pressed():
	Sfx.stream = load("res://src/sfx/one_shots/Synth-Sinsadhigher.wav")
	Sfx.play()
	Music.stop()
	get_tree().change_scene("res://src/gui/main_world_slide.tscn")
	
func _on_HowToPlayBtn_pressed():
	Sfx.stream = load("res://src/sfx/one_shots/Synth-Sinsad1.wav")
	Sfx.play()
	howtoplay_menu.popup_centered()
	
func _on_ControlsBtn_pressed():
	Sfx.stream = load("res://src/sfx/one_shots/Synth-Sinsad2.wav")
	Sfx.play()
	controls_menu.popup_centered()
	
func _on_SettingsBtn_pressed():
	Sfx.stream = load("res://src/sfx/one_shots/Synth-Sinsad1.wav")
	Sfx.play()
	settings_menu.popup_centered()
	
func _on_QuitBtn_pressed():
	get_tree().quit()


