extends Control
class_name MainMenu

@export var button_play_game: Button
@export var button_documentation: Button
@export var button_minigames: Button
@export var button_quit_game: Button
@export var button_back: Button

@export var menu_list: Array[MainMenuTab]
var current_menu_id: int = 0
var current_menu_container: Container
var menu_tree: Array
var gamemanager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_play_game.pressed.connect(play_game_pressed)
	button_documentation.pressed.connect(documentation_pressed)
	button_minigames.pressed.connect(minigames_pressed)
	button_quit_game.pressed.connect(quit_game_pressed)
	button_back.pressed.connect(back_button_pressed)
	
	button_play_game.grab_focus()
	
	gamemanager = find_parent("MainScene") as GameManager
	
	for menu in menu_list:
		menu.visible = false
		menu.initialize(self)
	
	set_menu_tab(0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_gamemanager(newManager: GameManager):
	gamemanager = newManager		
	print("GameManager set.")

func play_game_pressed():
	if gamemanager == null:
		gamemanager = find_parent("MainScene") as GameManager
	gamemanager.start_playing_all_minigames()

func minigames_pressed():
	set_menu_tab(1)

func documentation_pressed():
	set_menu_tab(2)

func quit_game_pressed():
	get_tree().quit()

func back_button_pressed():
	menu_tree.pop_back()
	
	if(menu_tree.size() > 0):
		open_menu(menu_tree.back())

func set_menu_tab(index: int):
	
	if menu_list.size() > index:
		pass
	
	open_menu(menu_list[index])

func open_menu(newMenuTab: MainMenuTab):
	if current_menu_container != null:
		current_menu_container.close()
	
	current_menu_id = menu_list.find(newMenuTab)
	current_menu_container = newMenuTab
	current_menu_container.open()
	button_back.visible = current_menu_container.showBackButton
	
	if !menu_tree.has(newMenuTab):
		if(current_menu_container.root == false):
			menu_tree.push_back(current_menu_container)
		else:
			menu_tree.clear()
			menu_tree.push_back(current_menu_container)
