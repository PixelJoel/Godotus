extends Control
class_name MinigameInfoScreen

@export var splash_rect: TextureRect 
@export var no_splash_label: Label
@export var game_name_field: Label
@export var author_field: Label
@export var description_field: Label
@export var button_play: Button

var gamemanager: GameManager

var current_game: MinigameInfo

func _ready() -> void:
	button_play.pressed.connect(on_button_play_pressed)
	show_game_info(null)

func initialize(gameManager: GameManager):
	gamemanager = gameManager

func show_game_info(gameInfo: MinigameInfo):
	if gameInfo == null: 
		current_game = null
		splash_rect.texture = null
		no_splash_label.visible = true
		game_name_field.text = "No game selected..."
		author_field.text = ""
		description_field.text = ""
		button_play.visible = false
	else:
		current_game = gameInfo
		
		if gameInfo.splash_screen_image != null:
			splash_rect.texture = gameInfo.splash_screen_image
			no_splash_label.visible = false
		else:
			splash_rect.texture = null
			no_splash_label.visible = true
			
		game_name_field.text = gameInfo.gameName
		author_field.text = "Author: " + gameInfo.author
		description_field.text = gameInfo.description
		button_play.visible = true


func on_button_play_pressed():
	if current_game != null:
		gamemanager.start_single_minigame(current_game)
	else:
		print("No current game set!")
