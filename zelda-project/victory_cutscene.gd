extends Node2D

@onready var hero = $Hero
@onready var wizard = $Wizard
@onready var name_label = $HUDLayer/DialogPanel/NameLabel
@onready var text_label = $HUDLayer/DialogPanel/TextLabel
@onready var press_label = $HUDLayer/DialogPanel/PressLabel
@onready var line_timer: Timer = $LineTimer

var lines = []
var current_index: int = -1
var waiting_for_input: bool = true

func _ready() -> void:
	press_label.visible = false
	lines = [
{"name": "Narrator", "text": "Our hero finds a powerful amulet on the ground."},
	{"name": "Hero", "text": "This is it. The amulet of Ultimate Curing. It is time to take the fight to the wizard."}
]
	line_timer.timeout.connect(_on_line_timer_timeout)
	_next_line()

func _on_line_timer_timeout() -> void:
	_next_line()

func _next_line() -> void:
	current_index += 1
	if current_index >= lines.size():
		line_timer.stop()
		_end_cutscene()
		return

	_update_line()

# Wizard and hero idle at the start
#	wizard.visible = true
#	hero.visible = true
#
#	current_index = 0
#	waiting_for_input = true
#	_update_line()

func _process(_delta: float) -> void:
	if waiting_for_input:
		if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_SPACE):
			_next_line()


func _update_line() -> void:
	var line = lines[current_index]
	var speaker = line["name"]
	var text = line["text"]
	name_label.text = speaker
	text_label.text = text

# Simple actions tied to specific lines
	if speaker == "Wizard" and text.find("In a week's time you will die") != -1:
	# Curse line, you can add effects later
		pass

	if speaker == "Narrator" and text.find("wizard vanishes") != -1:
		wizard.visible = false

	if speaker == "Hero" and text.find("fix this fast") != -1:
	# Last line, you could play a run animation if you have one
		pass
func _end_cutscene() -> void:
# Go to your main game scene here
	get_tree().change_scene_to_file("res://Main.tscn")
