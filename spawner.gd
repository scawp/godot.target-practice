extends Node2D

@export var target_scene: PackedScene
@export var spawn_points: Array[Marker2D]
@export var spawn_rate: float = 1.0
@export var spawn_on_death := true
#var targets: Array[PackedScene] 
var min: Vector2i
var max: Vector2i
var hard_mode = false

func spawn_new():
	var new_target = target_scene.instantiate()

	if hard_mode:
		new_target.scale = Vector2(0.667, 0.667)

	new_target.start_position(
		Vector2i(
			randi_range(min.x, max.x), 
			randi_range(min.y, max.y)))
	new_target.connect("target_cords", _on_target_cords)
	add_child(new_target)
	await get_tree().create_timer(spawn_rate).timeout
	if spawn_on_death == false:
		spawn_new()
	
func clamp_spawn_points():
	min = Vector2i(3, 3)#get_window().get_min_size()
	max = Vector2i(317, 197)#get_window().get_max_size()

# Called when the node enters the scene tree for the first time.
func _ready():
	%ExciteText.text = ""
	clamp_spawn_points()
	spawn_new()

func _on_target_cords(cords: Vector2):
	var dist: float = cords.distance_to(Vector2(0,0))
	print("cords", cords)
	print("distence:", dist)
	var label := "Near miss :("
	var multi := false
	var enabled := false
	var enableBounce := false
	var height = %ExciteText.height
	if dist < 3:
		#$"../../../AudioStreamPlayer2".play()
		label = "Perfect!!!"
		enabled = true
		multi = true
		height = 20
	elif dist < 4.5:
		label = "Good!!"
		if height < 10:
			height = 10
	elif dist < 17:
		label = "Okay."
	elif dist < 20:
		label = "Bad!"
	
	#TODO: remove this vomit
	%ExciteText.text = label
	%ExciteText.height = height
	%ExciteText.material.set_shader_parameter("multiColour", multi)
	%ExciteText.material.set_shader_parameter("enableBounce", enabled)
	%ExciteText.material.set_shader_parameter("fadeOut", 2)
	$"../../../AudioStreamPlayer".play()
	
	if spawn_on_death == true:
		spawn_new()
	
func _process(delta):
	var fade = %ExciteText.material.get_shader_parameter("fadeOut")
	fade -= delta
	%ExciteText.material.set_shader_parameter("fadeOut",fade)
	pass
	
func _unhandled_input(event):
	pass

