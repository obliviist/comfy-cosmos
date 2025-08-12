extends Node2D

func _ready():
	Music.stop()
	$AnimationPlayer.play("intro_fade_in")
	yield(get_tree().create_timer(8), "timeout")
	$AnimationPlayer.play("intro_fade_out")
	yield(get_tree().create_timer(6), "timeout")
	get_tree().change_scene("res://src/gui/start_screen.tscn")
