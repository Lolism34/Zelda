extends Node2D

@export var room_scenes: Array[String] = [
	"res://Room_01.tscn",
	"res://Room_02.tscn",
	"res://Room_03.tscn"
]

var current_room_index: int = 0
var current_room: Node2D

@onready var room_root: Node2D = $"../RoomRoot"
@onready var player: CharacterBody2D = $"../Player"
@onready var cam: Camera2D = $"../Camera2D"
#@onready var fade_rect: ColorRect = $"../CanvasLayer/FadeRect"

var room_size: Vector2 = Vector2(320, 180)

func _ready() -> void:
	_load_room(current_room_index, Vector2.ZERO, true)

func _load_room(index: int, enter_dir: Vector2, first: bool) -> void:
	if current_room:
		current_room.queue_free()

	var scene := load(room_scenes[index]) as PackedScene
	current_room = scene.instantiate() as Node2D
	room_root.add_child(current_room)

	var spawn := current_room.get_node_or_null("PlayerSpawn") as Marker2D
	var spawn_pos := Vector2.ZERO

	if spawn:
		spawn_pos = spawn.global_position
	else:
		spawn_pos = Vector2.ZERO

	if first:
		player.global_position = spawn_pos
	else:
		var offset := Vector2.ZERO
		if enter_dir == Vector2.RIGHT:
			offset = Vector2(-16, 0)
		elif enter_dir == Vector2.LEFT:
			offset = Vector2(16, 0)
		elif enter_dir == Vector2.UP:
			offset = Vector2(0, 16)
		elif enter_dir == Vector2.DOWN:
			offset = Vector2(0, -16)
		player.global_position = spawn_pos + offset

	cam.global_position = current_room.global_position

func request_room_change(new_index: int, move_dir: Vector2) -> void:
	if new_index < 0 or new_index >= room_scenes.size():
		return
	if new_index == current_room_index:
		return

	player.set_physics_process(false)

	var current_pos := cam.global_position
	var target_pos := current_pos + Vector2(
		room_size.x * move_dir.x,
		room_size.y * move_dir.y
	)

	var tween := create_tween()
	tween.tween_property(cam, "global_position", target_pos, 0.5)
	tween.tween_callback(func():
		current_room_index = new_index
		_load_room(current_room_index, move_dir, false)
		cam.global_position = current_room.global_position
		player.set_physics_process(true)
	)
