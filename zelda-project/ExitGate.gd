extends Area2D

@export var target_room_index: int = 0
@export var enter_from: String = ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name != "Player":
		return

	var gm := get_tree().root.get_node("Main/GameManager")
	if gm == null:
		return
	gm.enter_from = enter_from
	gm.request_room_change(target_room_index)
