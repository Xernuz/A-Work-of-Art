extends Node2D

func _ready():
	var climb_area = $ClimbArea
	climb_area.body_entered.connect(_on_climb_area_body_entered)
	climb_area.body_exited.connect(_on_climb_area_body_exited)

func _on_climb_area_body_entered(body: Node) -> void:
	if body.has_method("start_climbing"):
		body.start_climbing()

func _on_climb_area_body_exited(body: Node) -> void:
	if body.has_method("stop_climbing"):
		body.stop_climbing()
