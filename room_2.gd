extends Area2D

@export var room_name: String = "room2" 

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		var level = get_tree().current_scene
		if level:
			level.set_camera_limits_for_room(room_name)
