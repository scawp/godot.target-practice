extends Node2D

signal target_cords(cords)

@export var holes_scene: PackedScene

@onready var spawn_time := Time.get_ticks_msec()
var end_time := 0.0
var latancy := 0.0
var missed := false

var despawn := 0.0

var hit_point := Vector2i()

var prio = 0
var mouse_entered = false
var colliding_with = {}

static var total_latancy = 0.0
static var total_targets = 0
static var total_hit_point = Vector2i()
static var next_prio := 0
static var summary = false

func reset_hack():
	total_latancy = 0.0
	total_targets = 0
	total_hit_point = Vector2i()
	next_prio = 0
	summary = false
	

# Called when the node enters the scene tree for the first time.
func _ready():
	prio = next_prio 
	next_prio += 1
	z_index = prio
	
	if despawn > 0.0:
		await get_tree().create_timer(despawn).timeout
		missed = true
		hide()

func _init():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_holes():
	summary = true
	for child in $"../TargetSpawner".get_children():
		if child.end_time > 0.0: #if was shot
			var new_hole = holes_scene.instantiate()
			new_hole.position = child.hit_point
			add_child(new_hole)
			$"../../../AudioStreamPlayer".playing = true
			
			%ExciteText.text = str(child.latancy) + "s"
			%ExciteText.height = 20
			%ExciteText.material.set_shader_parameter("enableBounce", true)
			%ExciteText.material.set_shader_parameter("fadeOut", 2)
			
			await get_tree().create_timer(clampf(child.latancy / 2.0, 0.2, 0.5)).timeout
			spawn_holes
	

func _on_area_2d_input_event(viewport, event, shape_idx):
	if summary:
		return false
		
	#if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
	if (event is InputEventMouseButton) and event.pressed:
		for other_target in colliding_with:
			if colliding_with[other_target].prio > prio:
				if colliding_with[other_target].is_visible_in_tree():
					if colliding_with[other_target].mouse_entered:
						return false
		
		end_time = Time.get_ticks_msec()
		latancy = (end_time - spawn_time) / 1000
		total_latancy += latancy
		total_targets += 1
		$"../../../../GUI/VBoxContainer/LatencyContainer/LatencyScore".text = str(snapped(latancy, 0.01))
		$"../../../../GUI/VBoxContainer/AvgContainer2/AvgScore".text = str(snapped(total_latancy / total_targets, 0.01)) + "s"
		$"../../../../GUI/VBoxContainer/AvgContainer/AvgScore".text = str(total_targets)
		
		hit_point = ceil(get_local_mouse_position())
		total_hit_point += hit_point
		$"../../../../GUI/VBoxContainer/AccuracyContainer/AccurracyScore".text = str(total_hit_point / total_targets)
		
		
		#print(str(event))
		#print("Local cords:" + str(ceil(get_local_mouse_position())))
		target_cords.emit(get_local_mouse_position())
		#print(str(get_local_mouse_position().distance_to(Vector2(0,0))))
		hide()
		get_viewport().set_input_as_handled()

func start_position(pos: Vector2i):
	#print("Where we starting: " + str(pos))
	position = pos
	
#func _unhandled_input(event):
#	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
#		#print("Viewport:" + str(viewport))
#		print("unhandled")
#		print("Local cords:" + str(ceil(get_local_mouse_position())))


func _on_area_2d_mouse_entered():
	mouse_entered = true


func _on_area_2d_mouse_exited():
	mouse_entered = false


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	#print("on enter area")
	colliding_with[area_rid] = area.get_parent()
	pass # Replace with function body.


func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	#print("on exit area")
	colliding_with.erase(area_rid) 
	pass # Replace with function body.


