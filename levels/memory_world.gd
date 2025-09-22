extends Spatial

onready var world_env = $WorldEnvironment

func _ready():
	world_env.environment.dof_blur_far_enabled = false
	world_env.environment.dof_blur_near_enabled = false
	Music.stream = load("res://src/music/prancer_and_dancer_loop.wav") 
	Music.play()
	Amb.stream = load("res://src/sfx/amb_loops/wind1.wav")
	Amb.play()
