extends RayCast

onready var prompt = $Prompt
onready var mouth = $Mouth
onready var open_door = $OpenDoor
onready var crosshair = $CenterContainer/Crosshair

func _ready():
	add_exception(owner)
	
func _physics_process(_delta):
	prompt.text = ""
	mouth.visible = false
	open_door.visible = false
	crosshair.visible = true
	if is_colliding():
		var detected = get_collider()
		prompt.visible = true
		
		if detected is Interactable:
			prompt.text = detected.name
			
		if detected is NonPlayerCharacter:
			mouth.visible = true
			crosshair.visible = false
		
		if detected is Gate:
			open_door.visible = true
		
