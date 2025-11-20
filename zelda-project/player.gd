extends CharacterBody2D

@export var speed: float = 120.0
@export var max_health: int = 3

var current_health: int
var move_dir: Vector2 = Vector2.DOWN
var is_attacking: bool = false
var rupees: int = 0
var keys: int = 0
var hud

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_hitbox: Area2D = $SwordHitbox
@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	current_health = max_health
	sword_hitbox.monitoring = false
	sword_hitbox.monitorable = false
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	sword_hitbox.body_entered.connect(_on_sword_body_entered)
	

func _physics_process(delta: float) -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_vec := Vector2.ZERO
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vec.length() > 0.0:
		input_vec = input_vec.normalized()
		move_dir = input_vec
		velocity = input_vec * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	_update_animation(input_vec)

	if Input.is_action_just_pressed("attack"):
		_start_attack()

func _update_animation(input_vec: Vector2) -> void:
	var state := ""
	if velocity.length() == 0.0:
		state = "idle_"
	else:
		state = "walk_"

	var dir_name := ""
	if abs(move_dir.x) > abs(move_dir.y):
		if move_dir.x > 0.0:
			dir_name = "right"
		else:
			dir_name = "left"
	else:
		if move_dir.y > 0.0:
			dir_name = "down"
		else:
			dir_name = "up"

	var anim_name := state + dir_name
	if anim.animation != anim_name:
		anim.play(anim_name)

func _start_attack() -> void:
	if is_attacking:
		return

	is_attacking = true
	velocity = Vector2.ZERO

	var dir_name := ""
	if abs(move_dir.x) > abs(move_dir.y):
		if move_dir.x > 0.0:
			dir_name = "right"
		else:
			dir_name = "left"
	else:
		if move_dir.y > 0.0:
			dir_name = "down"
		else:
			dir_name = "up"

	var anim_name := "attack_" + dir_name
	anim.play(anim_name)

	_position_sword_hitbox(dir_name)
	sword_hitbox.monitoring = true
	sword_hitbox.monitorable = true
	attack_timer.start()

func _position_sword_hitbox(dir_name: String) -> void:
	var offset := Vector2.ZERO
	var dist := 14.0

	match dir_name:
		"up":
			offset = Vector2(0, -dist)
		"down":
			offset = Vector2(0, dist)
		"left":
			offset = Vector2(-dist, 0)
		"right":
			offset = Vector2(dist, 0)

	sword_hitbox.position = offset

func _on_attack_timer_timeout() -> void:
	is_attacking = false
	sword_hitbox.monitoring = false
	sword_hitbox.monitorable = false

func _on_sword_body_entered(body: Node) -> void:
	if body is Enemy:
		body.take_damage(1)
		
func take_damage(amount: int) -> void:
	current_health -= amount
	if hud != null:
		hud.set_hearts(current_health, max_health)
		if current_health <= 0:
			queue_free()

#Update when you pick up rupees or keys:

func add_rupees(amount: int) -> void:
	rupees += amount
	if hud != null:
		hud.set_rupees(rupees)

func add_key() -> void:
	keys += 1
	if hud != null:
		hud.set_keys(keys)
		
		hud = get_tree().get_root().find_child("HUD", true, false)
	if hud != null:
		hud.set_hearts(current_health, max_health)
		hud.set_rupees(rupees)
		hud.set_keys(keys)
