extends Node2D

var room_bounds = {
	"room1": Rect2(Vector2(10, -571), Vector2(565, 571)),
	"room2": Rect2(Vector2(555, -697), Vector2(565, 270)),
}

func _ready():
	set_camera_limits_for_room("room1")

func set_camera_limits_for_room(room_name: String) -> void:
	if room_bounds.has(room_name):
		var rect = room_bounds[room_name]
		var cam = get_node("player/Camera2D")
		if cam:
			cam.set_camera_limits(rect)
