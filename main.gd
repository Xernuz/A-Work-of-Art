extends Node2D

var room_bounds = {
	"room1": Rect2(Vector2(10, -571), Vector2(565, 571)),
	"room2": Rect2(Vector2(555, -697), Vector2(565, 697)),
	"room3": Rect2(Vector2(1120, -697), Vector2(974, 697)),
}

func _ready():
	set_camera_limits_for_room("room1")

func set_camera_limits_for_room(room_name: String) -> void:
	if room_bounds.has(room_name):
		var rect = room_bounds[room_name]
		var cam = get_node("player/Camera2D")
		if cam:
			cam.set_camera_limits(rect)

var spawn_points := {
	"spawn1": Vector2(1216, -512)
}  # Dictionary of spawn points: {"screen_name": Vector2}

func get_current_room(pos: Vector2) -> String:
	for room_name in room_bounds.keys():
		if room_bounds[room_name].has_point(pos):
			return room_name
	return ""

func get_respawn_position(pos: Vector2) -> Vector2:
	var room = get_current_room(pos)
	return spawn_points.get(room, Vector2.ZERO)
