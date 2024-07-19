extends Node2D

## Hello! this code was written badly
## Don't judge
## First to learn how to do something well,
## you have to learn how to do it badly ;)

var end_screen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("Quit"):
		get_tree().quit()
		
	if event.is_action_pressed("Reload"):
		end_screen = false
		get_tree().reload_current_scene()

	if event.is_action_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == 0:
			DisplayServer.window_set_mode(4)
		else:
			DisplayServer.window_set_mode(0)
	
	if event.is_action_pressed("End Screen") and !end_screen and !$"Main Menu".is_visible_in_tree():
		show_end_screen()


func show_end_screen():
	end_screen = true
	$SubViewportContainer/SubViewport2/TargetSpawner.visible = false
	$SubViewportContainer/SubViewport2/Summary.visible = true
	$GUI/VBoxContainer.visible = true
	$SubViewportContainer/SubViewport2/Summary.spawn_holes()


func _on_easy_pressed():
	$SubViewportContainer/SubViewport2/TargetSpawner.hard_mode = false
	$GUI.visible = true
	$"Main Menu".visible = false
	$SubViewportContainer/SubViewport2/TargetSpawner.visible = true
	$AudioStreamPlayer2.play()
	$SubViewportContainer/SubViewport2/TargetSpawner.spawn_new(true)
	get_viewport().set_input_as_handled()


func _on_hard_pressed():
	$SubViewportContainer/SubViewport2/TargetSpawner.hard_mode = true
	$GUI.visible = true
	$"Main Menu".visible = false
	$SubViewportContainer/SubViewport2/TargetSpawner.visible = true
	$AudioStreamPlayer2.play()
	$SubViewportContainer/SubViewport2/TargetSpawner.spawn_new(true)
	get_viewport().set_input_as_handled()


func _on_harder_pressed():
	$SubViewportContainer/SubViewport2/TargetSpawner.hard_mode = false
	$SubViewportContainer/SubViewport2/TargetSpawner.spawn_on_death = false
	$SubViewportContainer/SubViewport2/TargetSpawner.despawn_on = true
	$SubViewportContainer/SubViewport2/TargetSpawner.max_spawns = 20
	$GUI.visible = true
	$"Main Menu".visible = false
	$SubViewportContainer/SubViewport2/TargetSpawner.visible = true
	$AudioStreamPlayer2.play()
	$SubViewportContainer/SubViewport2/TargetSpawner.spawn_new(true)
	get_viewport().set_input_as_handled()


func _on_harderer_pressed():
	$SubViewportContainer/SubViewport2/TargetSpawner.hard_mode = false
	$SubViewportContainer/SubViewport2/TargetSpawner.harderer_mode = true
	$SubViewportContainer/SubViewport2/TargetSpawner.spawn_on_death = false
	$SubViewportContainer/SubViewport2/TargetSpawner.despawn_on = true
	$SubViewportContainer/SubViewport2/TargetSpawner.max_spawns = 20
	$SubViewportContainer/SubViewport2/TargetSpawner.spawn_rate = 0.8
	$SubViewportContainer/SubViewport2/TargetSpawner.despawn_rate = 1.6
	$GUI.visible = true
	$"Main Menu".visible = false
	$SubViewportContainer/SubViewport2/TargetSpawner.visible = true
	$AudioStreamPlayer2.play()
	$SubViewportContainer/SubViewport2/TargetSpawner.spawn_new(true)
	get_viewport().set_input_as_handled()
