extends VBoxContainer
## Script that shows the right keys in the splash screen based on the input from the MinigameInfo
class_name Splash_ButtonInstructions

@export var font_size = 32

@export var mouse_left_texture: Texture2D
@export var key_w_texture: Texture2D
@export var key_a_texture: Texture2D
@export var key_s_texture: Texture2D
@export var key_d_texture: Texture2D


func setup(info: MinigameInfo):
	var i = 0
	for child in get_children():
		remove_child(child)
	add_spacer(true)
	for instruction in info.button_instructions:
		# Create a new horizontal line for new instruction. Add it as child of this node (This should be a VBox)
		var container: Container = Container.new()
		container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		var horizontalLine: HBoxContainer = HBoxContainer.new()
		horizontalLine.size_flags_vertical = Control.SIZE_EXPAND
		horizontalLine.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		horizontalLine.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
		horizontalLine.alignment = BoxContainer.ALIGNMENT_CENTER
		add_child(container)
		container.add_child(horizontalLine)
		
		# Add every button described in the instruction into the horizontal line 
		for button in instruction.buttonIcons:
			#var container: Control = Container.new()
			#horizontalLine.add_child(container)
			
			var textureContainer: TextureRect = TextureRect.new()
			#container.add_child(textureContainer)
			textureContainer.texture = get_button(button)
			textureContainer.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			textureContainer.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
			horizontalLine.add_child(textureContainer)
		
		# Create a label for the description
		var descriptionLabel: Label = Label.new()
		descriptionLabel.add_theme_font_size_override("font_size", font_size)
		descriptionLabel.text = ": " + instruction.description
		horizontalLine.add_child(descriptionLabel)
		
		var tween = horizontalLine.create_tween().set_parallel(true)
		var posY = horizontalLine.position.y
		horizontalLine.position.y = 50
		horizontalLine.modulate.a = 0
		tween.tween_property(horizontalLine, "modulate:a", 1, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(horizontalLine, "position:y", posY, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay(i * 0.1)
		
		i += 1
		#tween.tween_callback(horizontalLine.queue_free)


func get_button(key: ButtonInstruction.ButtonIcon) -> Texture2D:
	match key:
		ButtonInstruction.ButtonIcon.MouseLeft:
			return mouse_left_texture
		ButtonInstruction.ButtonIcon.W:
			return key_w_texture
		ButtonInstruction.ButtonIcon.A:
			return key_a_texture
		ButtonInstruction.ButtonIcon.S:
			return key_s_texture
		ButtonInstruction.ButtonIcon.D:
			return key_d_texture
	return null
