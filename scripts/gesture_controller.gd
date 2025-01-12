extends Node2D
class_name GestureController

var gesture_buttons: Array[Node]
@export var controller_data: GestureControllerResource
var gesture_shape_scene = preload("res://scenes/gesture_shape.tscn")
@onready var viewport_size = get_viewport().size

signal toggle_controller_active(v: bool)
signal reset

var controller_active := false:
	set(v):
		controller_active = v
		toggle_controller_active.emit(v)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var max_size := Vector2.ZERO
	var i = 0
	for button_data in controller_data.shapes_array:
		var scene = gesture_shape_scene.instantiate()
		gesture_buttons.append(scene) 
		add_child(scene)
		scene.update_data(button_data.duplicate())
		scene.data.input_data.input[0] = i
		var pos_angle: float = TAU / controller_data.shapes_array.size() * i
		max_size = bounding_box(max_size, scene.area_shape, button_data.start_angle + pos_angle)
		i += 1
	
	print(max_size)
	var angle := TAU / controller_data.shapes_array.size()
	var angle2 := (PI - angle) / 2
	var triangle_side := max_size.x * sin(angle2) / sin(angle)
	var offset: float = sqrt(pow(triangle_side, 2) - pow(max_size.x / 2, 2)) + max_size.y / 2
	for j in controller_data.shapes_array.size():
		var pos_angle := TAU / controller_data.shapes_array.size() * j
		var direction = Vector2(cos(pos_angle), sin(pos_angle))
		gesture_buttons[j].position += direction * offset
		gesture_buttons[j].rotate(pos_angle)
		print(pos_angle)

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("space")):
		controller_active = true
	
	if (Input.is_action_pressed("space")):
		for button in gesture_buttons:
			if (button.hovered):
				print(button.data.input_data.input[0])
				
	
	if (Input.is_action_just_released("space")):
		controller_active = false
		reset.emit()
	pass

func bounding_box(max_size: Vector2, shape: Polygon2D, angle: float) -> Vector2:
	var x_max = 0
	var y_max = 0
	var x_min = viewport_size.y
	var y_min = viewport_size.y
	
	for point in shape.get_polygon():
		var rotated_point = Vector2(
			point.x * cos(angle) - point.y * sin(angle),
			point.x * sin(angle) + point.y * cos(angle)
		)
		x_max = max(x_max, rotated_point.x)
		y_max = max(y_max, rotated_point.y)
		x_min = min(x_min, rotated_point.x)
		y_min = min(y_min, rotated_point.y)
	
	var x_delta = x_max - y_min # width
	var y_delta = y_max - y_min # height
	
	max_size.x = max(x_delta, max_size.x)
	max_size.y = max(y_delta, max_size.y)
	
	return max_size
