extends Resource
class_name GestureShapeResource


enum Shape {RECT, ARC, CIRCLE, FREE}
@export var shape := Shape.RECT
@export var fill := true
@export_group("Input")
@export var unique_input := true
@export var input_data: InputDataResource

@export_group("Shape data")
@export_range(0, 360, 0.5, "radians_as_degrees") var start_angle: float = 0.0
@export_range(0, 360, 0.5, "radians_as_degrees") var end_angle: float = 90.0
@export var size := Vector2.ZERO
@export var center := Vector2.ZERO

@export_group("Colors")
@export var color_primary := Color.WHITE
@export var color_secondary := Color.WEB_GREEN
@export var color_extra: PackedColorArray
@export var texture: Texture2D
