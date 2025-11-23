extends Area2D

@export var victory_scene_path: String = "res://victory_cutscene.tscn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name != "Player":
		return

# optional: hide item before scene change
	visible = false
	set_deferred("monitoring", false)

	get_tree().change_scene_to_file("res://victory_cutscene.tscn")
