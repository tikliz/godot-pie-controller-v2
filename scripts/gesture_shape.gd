extends Node2D
class_name GestureShape

@export var data: GestureShapeResource

@onready var area = $Area2D
@onready var area_collision = $Area2D/CollisionPolygon2D
@onready var area_shape = $Area2D/Polygon2D

var controller_active := false
var hovered := false
var enabled := false:
	set(v):
		enabled = v
		area_collision.disabled = !v

func reset() -> void:
	hovered = data.input_data.start_hovered
	enabled = !data.input_data.disabled
	area.visible = false

var local_points: Array[Vector2]:
	set(v):
		local_points = v
		area_collision.set_polygon(v)
		area_shape.set_polygon(v)

func _init(data: GestureShapeResource = GestureShapeResource.new()) -> void:
	self.data = data

func _ready() -> void:
	area.mouse_entered.connect (_on_area2D_mouse_entered)
	area.mouse_exited.connect(_on_area2D_mouse_exited)
	get_parent().toggle_controller_active.connect(_on_controller_active_toggle)
	get_parent().reset.connect(reset)
	update_data(data)
	reset()

func _on_area2D_mouse_entered() -> void:
	if (!data.input_data.disabled && controller_active):
		hovered = true

func _on_area2D_mouse_exited() -> void:
	if (!data.input_data.disabled && controller_active):
		hovered = false
		
func _on_controller_active_toggle(v: bool) -> void:
	controller_active = v
	if (v):
		area.visible = true

func update_data(data: GestureShapeResource) -> void:
	self.data = data
	
	if (self.data.unique_input):
		self.data.input_data = self.data.input_data.duplicate()
	
	
	match data.shape:
		GestureShapeResource.Shape.RECT:
			var shape_points: Array[Vector2] = gen_rect(data.center, data.size)
			local_points = shape_points
			self.position = get_viewport().size / 2

func gen_rect(center: Vector2, size: Vector2) -> Array[Vector2]:
	var hw := size.x / 2
	var hh := size.y / 2
	
	return [
		Vector2(center.x - hw, center.y - hh),
		Vector2(center.x + hw, center.y - hh),
		Vector2(center.x + hw, center.y + hh),
		Vector2(center.x - hw, center.y + hh)
	]
