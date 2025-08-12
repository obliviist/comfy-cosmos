extends Popup

func _ready():
	pass

func _on_CloseBtn_pressed():
	Sfx.stream = load("res://src/sfx/one_shots/Drums-CappucinoSnare.wav")
	Sfx.play()
	self.hide()
