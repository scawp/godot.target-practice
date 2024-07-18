extends Node2D

var show_menu = true
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
		
	#if event.is_action_pressed("Reload"):
	#	get_tree().reload_current_scene()

	if event.is_action_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == 0:
			DisplayServer.window_set_mode(4)
		else:
			DisplayServer.window_set_mode(0)
	
	if $"Main Menu".visible:
		if event.is_action_pressed("Hard Mode"):
			$SubViewportContainer/SubViewport2/TargetSpawner.hard_mode = !$SubViewportContainer/SubViewport2/TargetSpawner.hard_mode

		if (event is InputEventMouseButton) and event.pressed:
			$GUI.visible = true
			$"Main Menu".visible = false
			$SubViewportContainer/SubViewport2/TargetSpawner.visible = true
			$AudioStreamPlayer2.play()
			get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("End Screen") and !end_screen:
		end_screen = true
		$SubViewportContainer/SubViewport2/TargetSpawner.visible = false
		$SubViewportContainer/SubViewport2/Summary.visible = true
		$GUI/VBoxContainer.visible = true
		$SubViewportContainer/SubViewport2/Summary.spawn_holes()
