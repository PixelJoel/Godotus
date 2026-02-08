extends Node


# Made by Pixel Joel

## Global singleton that gives out handy functions for the minigames.
## It includes button inputs already set up, as well as the functions for winning or losing the minigame.
# ⚠️ ONLY MODIFY THIS SCRIPT IN ACTUAL NEED. ALSO, THE MODIFICATION HAS TO BE PROPAGATED INTO THE MAIN BUILD OF THE GAME ⚠️ 
# ⚠️ MODIFICATIONS OF THIS SCRIPT AFFECTS EVERY MINIGAME ⚠️

## Maximum health of the player
var player_max_hp: int = 3
## Current health of the player. When the health reaches zero, game is over!
var player_current_hp: int = 3

## Event that is emitted when the minigame is won
signal minigame_won
## Event that is emitted when the minigame is lost
signal minigame_lost
## Global memory of minigames. Memory will be wiped when the game run ends.
var minigame_globals: Dictionary = {}

func _ready() -> void:
	print("Global initiated.")
	pass # Replace with function body.

func _process(delta: float) -> void:
	handle_tick_input()

## Calling this function will win the minigame
func win_minigame() -> void:
	print("Won the game! Current health: " + var_to_str(player_current_hp))
	minigame_won.emit()

## Calling this function will lose the minigame
func lose_minigame() -> void:
	minigame_lost.emit()

## Resets all variables in the Global script back to defaults
func reset_state() -> void:
	player_current_hp = player_max_hp
	minigame_globals.clear()
	pass


# ==============
# Input
# ==============

## Event emitted when pressing the primary button
signal button_primary_pressed
## Event emitted when pressing the left button
signal button_left_pressed
## Event emitted when pressing the right button
signal button_right_pressed
## Event emitted when pressing the up button
signal button_up_pressed
## Event emitted when pressing the down button
signal button_down_pressed

## Event emitted when the primary button is released
signal button_primary_released
## Event emitted when the left button is released
signal button_left_released
## Event emitted when the right button is released
signal button_right_released
## Event emitted when the up button is released
signal button_up_released
## Event emitted when the down button is released
signal button_down_released

## Is button "primary" pressed?
var button_primary: bool = false
## Is button "left" pressed?
var button_left: bool = false
## Is button "right" pressed?
var button_right: bool = false
## Is button "up" pressed?
var button_up: bool = false
## Is button "down" pressed?
var button_down: bool = false

## Horizontal input axis mapped in -1 to 1 range. Right +1 and Left -1
var axis_horizontal: float = 0.0
## Vertical input axis mapped in -1 to 1 range. Up +1 and Down -1
var axis_vertical: float = 0.0
## Vector2 input axis. Horizontal in X, and Vertical in Y
var input_axis_2D: Vector2 = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	# PRESSED SIGNALS
	if event.is_action_pressed("primary"):
		button_primary_pressed.emit()
		button_primary = true
	if event.is_action_pressed("left"):
		button_left_pressed.emit()
		button_left = true
	if event.is_action_pressed("right"):
		button_right_pressed.emit()
		button_right = true
	if event.is_action_pressed("up"):
		button_up_pressed.emit()
		button_up = true
	if event.is_action_pressed("down"):
		button_down_pressed.emit()
		button_down = true

	# RELEASED SIGNALS
	if event.is_action_released("primary"):
		button_primary_released.emit()
		button_primary = false
	if event.is_action_released("left"):
		button_left_released.emit()
		button_left = false
	if event.is_action_released("right"):
		button_right_released.emit()
		button_right = false
	if event.is_action_released("up"):
		button_up_released.emit()
		button_up = false
	if event.is_action_released("down"):
		button_down_released.emit()
		button_down = false

func handle_tick_input():
	# AXIS HANDLING
	var x = input_axis_2D.x
	var y = input_axis_2D.y
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if Input.get_action_strength("left") > 0 or Input.get_action_strength("right") > 0:
			axis_horizontal = Input.get_action_strength("right") - Input.get_action_strength("left")
			x = axis_horizontal
		else:
			axis_horizontal = 0
			x = 0
	else:
		axis_horizontal = 0
		x = 0
	if Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		if Input.get_action_strength("up") > 0 or Input.get_action_strength("down") > 0:
			axis_vertical = Input.get_action_strength("up") - Input.get_action_strength("down")
			y = axis_vertical
		else:
			axis_vertical = 0
			y = 0
	else:
		axis_vertical = 0
		y = 0
	input_axis_2D = Vector2(x,y)
	pass
