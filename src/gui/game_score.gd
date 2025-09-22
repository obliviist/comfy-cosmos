extends Label

onready var cassette_score = Dialogic.get_variable("cassette_score") 

func _process(delta):
	self.text = str(GlobalSettings.score)
	
func _on_Score_body_entered(body):
		if body.is_in_group("score"):
			GlobalSettings.score += 1
			body.remove_from_group("score")
			
			if GlobalSettings.score == 1:
				Dialogic.set_variable("cassette_score", 1)
			if GlobalSettings.score == 2:
				Dialogic.set_variable("cassette_score", 2)
			if GlobalSettings.score == 3:
				Dialogic.set_variable("cassette_score", 3)
			if GlobalSettings.score == 3:
				Dialogic.set_variable("cassette_score", 4)
