extends Node2D
#Background process for the game

var money: int = 100

var build_mode = false

var box_ref: PackedScene
var box_price: int = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	box_ref = preload("res://scenes/box.tscn")
	$GhostBox.z_index = 2
	$GhostBox.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Toggle building
	if Input.is_action_just_pressed("toggle_build_mode"):
		build_mode = not build_mode
		$GhostBox.visible = not $GhostBox.visible
	
	#Find out if box is placeable
	var box_placeable: bool = false
	$GhostBox.position = get_global_mouse_position()
	if $GhostBox.has_overlapping_bodies() or money < box_price:
		box_placeable = false
		$GhostBox/Cover.color = Color(255, 0, 0, 0.5)
	else:
		box_placeable = true
		$GhostBox/Cover.color = Color(0, 255, 0, 0.5)
	
	if Input.is_action_just_pressed("place_item") and box_placeable and build_mode:
		var new_box = box_ref.instantiate()
		new_box.position = get_global_mouse_position()
		add_child(new_box)
		money -= box_price
	
	
	#Update hud
	$Player/Camera2D/HUD/Money.text = "$" + str(money) 
