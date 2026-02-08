# GameManager.gd
extends Node
class_name GameManager

## MainMenu Scene
@export var mainmenu_scene: PackedScene
## Directory which from the minigames are searched
@export var minigame_directory: String = "res://Minigames"
## Splash screen scene used between minigames to show the player's hp, the title for the upcoming minigame and short tutorial for it. 
@export var splash_scene: PackedScene

var instanced_splash_screen: SplashScreen
var splash_screen_showing: bool = false

## All minigames snooped from the Minigamefolder
var loaded_minigames: Array[MinigameInfo]
## Minigames that are played in sequence
var current_minigame_list: Array[MinigameInfo] = []
var current_index: int = 0
var current_scene: Node = null
var minigame_in_queue: MinigameInfo = null
var currentState: GameState

enum GameState { MAINMENU, INGAME }




func _ready() -> void:
	Global.minigame_won.connect(on_minigame_won)
	Global.minigame_lost.connect(on_minigame_lost)
		
	scan_folder_for_minigames("res://Minigames", loaded_minigames)
	
	switch_to_scene(mainmenu_scene)
	print("current scene: ", current_scene)
	if current_scene is MainMenu:
		print("Hei!")
		current_scene.set_gamemanager(self)

## Unpack the scene and load it
func switch_to_scene(newScene: PackedScene):
	var instanced_scene = newScene.instantiate()
	switch_to_instanced_scene(instanced_scene)

## Switches the scene using instanced node instead of a packed scene
func switch_to_instanced_scene(newScene: Node):
	if current_scene and is_instance_valid(current_scene):
		current_scene.queue_free()
		current_scene = null
	Global.reset_state()
	var container := $SceneContainer
	container.add_child(newScene)
	current_scene = newScene

## Starts the process of going into the current minigame. First goes into splash screen, and from there into the minigame
func start_current_minigame() -> void:
	if current_minigame_list.is_empty():
		push_error("No minigames assigned to GameManager.")
		return
	if current_index < 0 or current_index >= current_minigame_list.size():
		current_index = 0
	var minigame_scene: MinigameInfo = current_minigame_list[current_index]
	minigame_in_queue = minigame_scene
	show_splash_screen(minigame_scene)

func start_playing_all_minigames() -> void:
	# Load all minigames into the minigame list
	current_minigame_list.clear()
	for game in loaded_minigames:
		current_minigame_list.push_back(game)
	start_current_minigame()

func start_single_minigame(miniGame: MinigameInfo):
	current_minigame_list.clear()
	current_minigame_list.append(miniGame)
	start_current_minigame()

func end_playing_minigames():
	current_index = 0
	Global.reset_state()
	switch_to_scene(mainmenu_scene)

## Connected function to listen when Global fires the event. If you want to exit your minigame with player winning it, use Global.win_minigame(), not this.
func on_minigame_won() -> void:
	if current_index >= current_minigame_list.size()-1:
		print("ENDING THE PLAYTHROUGH")
		end_playing_minigames()
		return
	else:
		# Move to next minigame if this wasn't the last minigame
		print("PLAYING NEXT MINIGAME: ", current_index)
		advance_current_scene()
		start_current_minigame()

## Connected function to listen when Global fires the event
func on_minigame_lost() -> void:
	if Global.player_current_hp > 0:
		advance_current_scene()
		start_current_minigame()
	else:
		print("Game Over")



func advance_current_scene() -> void:
	current_index = (current_index + 1) % loaded_minigames.size()


func instantiate_splash_screen() -> SplashScreen:
	var splash = splash_scene.instantiate()
	if splash is SplashScreen:
		splash.time_is_up.connect(on_splash_screen_timed_out)
	add_child(splash)
	return splash

func show_splash_screen(newMinigame: MinigameInfo):
	if instanced_splash_screen == null:
		instanced_splash_screen = instantiate_splash_screen()
	splash_screen_showing = true
	instanced_splash_screen.setup(newMinigame)
	instanced_splash_screen.show_splash_screen()

func on_splash_screen_timed_out():
	instanced_splash_screen.hide_splash_screen()
	splash_screen_showing = false
	if minigame_in_queue:
		var instantiated_minigame: Node = minigame_in_queue.minigameScene.instantiate()
		switch_to_instanced_scene(instantiated_minigame)
	else:
		push_error("No minigame in queue")




func scan_folder_for_minigames(path: String, out_array: Array[MinigameInfo]) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Cannot open folder: " + path)
		return

	dir.list_dir_begin()
	var dir_name := dir.get_next()

	while dir_name != "":
		if dir.current_is_dir():
			if dir_name != "." and dir_name != "..":
				var sub := path.path_join(dir_name)
				scan_folder_for_minigames(sub, out_array)
		else:
			if dir_name.ends_with(".tres"):
				var full := path.path_join(dir_name)
				var res := load(full)
				if res is MinigameInfo:
					out_array.append(res)
					print("Minigameinfo found: ", res.gameName)
		dir_name = dir.get_next()
	dir.list_dir_end()

## Function used for debug purposes! Use Global.{keyname} things for your game inputs! 
func _input(ev) -> void:
	if splash_screen_showing:
		return
	if Input.is_action_just_pressed("debug_skip"):
		Global.win_minigame()
