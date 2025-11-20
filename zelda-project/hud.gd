extends CanvasLayer

var max_hearts: int = 3
var current_hearts: int = 3

@onready var heart1: TextureRect = $Root/TopBar/Heart1
@onready var heart2: TextureRect = $Root/TopBar/Heart2
@onready var heart3: TextureRect = $Root/TopBar/Heart3
@onready var rupee_label: Label = $Root/TopBar/RupeeLabel
@onready var key_label: Label = $Root/TopBar/KeyLabel

func _ready() -> void:
	update_hearts()
	set_rupees(0)
	set_keys(0)

func set_hearts(current: int, max_val: int) -> void:
	current_hearts = clamp(current, 0, max_val)
	max_hearts = max_val
	update_hearts()

func update_hearts() -> void:
	var hearts = [heart1, heart2, heart3]
	for i in range(hearts.size()):
		if i < current_hearts:
			hearts[i].visible = true
		else:
			hearts[i].visible = false

func set_rupees(amount: int) -> void:
	rupee_label.text = "Rupees: " + str(amount)

func set_keys(amount: int) -> void:
	key_label.text = "Keys: " + str(amount)
