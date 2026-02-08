extends Control

class_name SplashScreen

@export var header: Label
@export var buttonInstructions: Splash_ButtonInstructions
@export var splash_image_rect: TextureRect
@export var anim_player: AnimationPlayer

@export var splash_screen_duration: float = 2
var currentTime: float = 0
var time_up_flag: bool = false
signal time_is_up

func setup(info: MinigameInfo):
	header.text = info.gameName
	var headerPosX = header.position.x
	header.position.x = headerPosX
	#var htween = create_tween()
	#htween.tween_property(header, "position:x", headerPosX, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	splash_image_rect.texture = info.splash_screen_image
	buttonInstructions.setup(info)
	
	# Set the timer variables
	currentTime = 0
	time_up_flag = false

func show_splash_screen():
	anim_player.play("Fade_In")
	print("SHOWING SPLASH")

func hide_splash_screen():
	anim_player.play("Fade_In", -1, -1.0, true)
	print("PLaying in reverse!!")

func _process(delta: float) -> void:
	if currentTime < splash_screen_duration:
		currentTime += delta
	elif time_up_flag == false:
		time_up_flag = true
		time_is_up.emit()
