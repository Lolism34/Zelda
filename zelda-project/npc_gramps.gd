extends Area2D

var player_in_range: bool = false
var dialog_active: bool = false
var current_index: int = -1

var lines: Array = [
{"name": "Hero", "text": "Hey Gramps!"},
{"name": "Gramps", "text": "Hey my boy. You have gotten yourself in a lot of trouble it seems."},
{"name": "Hero", "text": "Yep..."},
{"name": "Gramps", "text": "I am not surprised. I have been looking around this Mountain and I believe there is something here that can help you."},
{"name": "Hero", "text": "Why are you in the Mountains in the first place?"},
{"name": "Gramps", "text": "......We all have secrets, my boy."},
{"name": "Hero", "text": "Hmm..."}
]

var dialog_panel
var name_label
var text_label
var press_label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	dialog_panel = get_tree().get_root().find_child("DialogPanel", true, false)
	
	if dialog_panel != null:
		name_label = dialog_panel.get_node("NameLabel")
		text_label = dialog_panel.get_node("TextLabel")
		press_label = dialog_panel.get_node("PressLabel")
		dialog_panel.visible = false
func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_in_range = false
	if dialog_active:
		_end_dialog()

func _process(delta: float) -> void:
	if dialog_panel == null:
		return
	if player_in_range and not dialog_active:
		if Input.is_action_just_pressed("interact"):
			_start_dialog()
			return

	if dialog_active:
		if Input.is_action_just_pressed("interact"):
			_next_line()
func _start_dialog() -> void:
	dialog_active = true
	current_index = -1
	dialog_panel.visible = true
	press_label.visible = true
	_next_line()

func _next_line() -> void:
	current_index += 1
	if current_index >= lines.size():
		_end_dialog()
		return
	var line = lines[current_index]
	name_label.text = line["name"]
	text_label.text = line["text"]
func _end_dialog() -> void:
	dialog_active = false
	current_index = -1
	dialog_panel.visible = false
