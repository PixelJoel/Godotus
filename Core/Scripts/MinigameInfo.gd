extends Resource

class_name MinigameInfo

## Created by Pixel Joel
## MODIFYING THIS FILE AFFECTS ALL MINIGAMES AND MAY LEAD TO LOSS OF DATA!!! 

## Name of your game
@export var gameName: String = "New Game"
## Name of YOU
@export var author: String = "Me"
## Description of the game. What kind of a game have you made?
@export_multiline var description: String = "Description to be set up..."
## The scene your minigame is in
@export var minigameScene: PackedScene
## How difficult is your minigame?
@export var difficulty: CoreEnums.Difficulty = CoreEnums.Difficulty.EASY
## Genre of your minigame. For sorting purposes
@export var genre: CoreEnums.Genre = CoreEnums.Genre.MISCELLANIOUS
@export_group("Splash Screen")
## What buttons are used in the game? Set this up by adding a new element and assigning the key / multiple keys, and description for it. 
## Example: WASD: Move, Space: Shoot
@export var button_instructions: Array[ButtonInstruction]
## What picture is shown when 
@export var splash_screen_image: Texture2D
