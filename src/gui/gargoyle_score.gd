extends Label

onready var gargoyle_score = Dialogic.get_variable("gargoyle_score") 

func _process(delta):
	self.text = str(GlobalSettings.gargoyle_score)
	
func _on_Score_body_entered(body):
		if body.is_in_group("score"):
			GlobalSettings.gargoyle_score += 1
			body.remove_from_group("score")
			
			if GlobalSettings.score == 1:
				Dialogic.set_variable("gargoyle_score", 1)
			if GlobalSettings.score == 2:
				Dialogic.set_variable("gargoyle_score", 2)
			
				
