extends MainMenuTab

@export var buttonListParent: Container
@export var minigameInfoScreen: MinigameInfoScreen

var buttonList: Array[Button]
var scene_parent
var buttonSceneDic: Dictionary

func _ready():
	scene_parent = find_parent("MainScene")
	if scene_parent is GameManager:
		minigameInfoScreen.initialize(scene_parent)
		for game in scene_parent.loaded_minigames:
			var button = Button.new()
			buttonListParent.add_child(button)
			buttonList.push_back(button)
			buttonSceneDic[button] = game
			
			
			if game is MinigameInfo:
				button.text = game.gameName
				button.pressed.connect(on_list_button_pressed.bind(game))
			#button.text = var_to_str(gameInfo.name)

func on_list_button_pressed(gameInfo: MinigameInfo):
	minigameInfoScreen.show_game_info(gameInfo)


func open():
	super()
	if buttonList.size() > 0:
		buttonList[0].grab_focus()
