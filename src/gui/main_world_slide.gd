extends Node2D

func _ready():
	get_tree().paused = false
	$AnimationPlayer.play("intro_fade_in")
	yield(get_tree().create_timer(8), "timeout")
	$AnimationPlayer.play("intro_fade_out")
	yield(get_tree().create_timer(6), "timeout")
	get_tree().change_scene("res://levels/main_world.tscn")
