extends Node2D

func _ready():
	get_tree().paused = false
	$AnimationPlayer.play("intro_fade_in")
	yield(get_tree().create_timer(4), "timeout")
	$AnimationPlayer.play("intro_fade_out")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://levels/world_2.tscn")
