extends CharacterBody2D

@export var dash_granting := true

@onready var area = $Area2D
@onready var respawn_timer = $RespawnTimer

func _ready():
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	respawn_timer.connect("timeout", Callable(self, "_on_respawn_timeout"))

func _on_body_entered(body):
	if dash_granting and body.has_method("grant_dash"):
		body.grant_dash()
		call_deferred("_hide_orb")

func _hide_orb():
	visible = false
	$Area2D.monitoring = false
	$RespawnTimer.start()

func _on_respawn_timeout():
	visible = true
	area.monitoring = true
