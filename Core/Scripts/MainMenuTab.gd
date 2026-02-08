extends Container
class_name MainMenuTab

@export var root: bool
@export var showBackButton: bool

var main_menu: MainMenu
# Called when the node enters the scene tree for the first time.
func initialize(mainmenu: MainMenu) -> void:
	main_menu = mainmenu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Fired when the tab is opened
func open():
	visible = true
	
	var buttonList = find_all_buttons(self)
	if(buttonList.size() > 0):
		buttonList[0].grab_focus()
	else:
		main_menu.button_back.grab_focus()

## Fired when the tab is closed
func close():
	visible = false


func find_all_buttons(node: Node, buttons_array: Array[Button] = []) -> Array[Button]:
	for child in node.get_children():
		if child is Button:
			buttons_array.push_back(child)
		elif child is Control:
			find_all_buttons(child, buttons_array)
	return buttons_array

func find_first_button(node:Node) -> Button:
	var button: Button
	for child in node.get_children():
		if child is Button:
			button = child
		elif child is Control:
			button = find_first_button(child)
	return button
