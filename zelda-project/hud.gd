extends CanvasLayer

var max_hearts: int = 3
var current_hearts: int = 3

@onready var heart_label: Label = $HeartLabel
@onready var rupee_label: Label = $RupeeLabel
@onready var key_label: Label = $KeyLabel

func _ready() -> void:
	print("HUD ready. HeartLabel:", heart_label)
	update_hearts()
	set_rupees(0)
	set_keys(0)

func set_hearts(current: int, max_val: int) -> void:
	current_hearts = clamp(current, 0, max_val)
	max_hearts = max_val
	print("HUD.set_hearts current:", current_hearts, " max:", max_hearts)
	update_hearts()

func update_hearts() -> void:
	if heart_label == null:
		print("HeartLabel is null in update_hearts")
	else:
		heart_label.text = "Hearts: " + str(current_hearts) + " / " + str(max_hearts)
			
	
	

func set_rupees(amount: int) -> void:
	if rupee_label == null:
		print("RupeeLabel is null")
	return
	rupee_label.text = "Rupees: " + str(amount)

func set_keys(amount: int) -> void:
	if key_label == null:
		print("KeyLabel is null")
	return
	key_label.text = "Keys: " + str(amount)
