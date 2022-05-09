extends Control

####################### Consts
const SETTINGS_FILE = "user://settings.conf"

###################### Vars
var gameConfig = ConfigFile.new()
# Game Settings

# Video Settings
var setVDefaultDisplaySettings = true
var setVFullscreen = false
var resolutionOptions = [
	[3840,2160],
	[2560,1440],
	[1920,1080],
	[1280,720],
]
var setVDefaultResolutionSettings = true
var setVXResolution = 1280
var setVYResolution = 720

# Audio Settings
######################

func _ready():
	# Prep Resolution Optionsz
	get_node("Settings/Video Settings/Display Settings/ResolutionOptions").add_item("Default")
	for resOption in resolutionOptions:
		get_node("Settings/Video Settings/Display Settings/ResolutionOptions").add_item(str(resOption[0], "X", resOption[1]))
		
	load_settings()
	updateSettings()

func _input(event):
	if event is InputEventKey:
		if (event as InputEventKey).scancode == KEY_ESCAPE:
			_on_X_pressed()
			
func save_settings():
	# Game Settings

	# Video Settings
	gameConfig.set_value("Video Settings", "setVDefaultDisplaySettings", setVDefaultDisplaySettings)
	gameConfig.set_value("Video Settings", "setVFullscreen", setVFullscreen)
	gameConfig.set_value("Video Settings", "setVDefaultResolutionSettings", setVDefaultResolutionSettings)
	gameConfig.set_value("Video Settings", "setVXResolution", setVXResolution)
	gameConfig.set_value("Video Settings", "setVYResolution", setVYResolution)

	# Audio Settings

	gameConfig.save(SETTINGS_FILE)

func load_settings():
	var err = gameConfig.load(SETTINGS_FILE)
	if err != OK:
		print("Error Loading Config")
	
	for section in gameConfig.get_sections():
		setVDefaultDisplaySettings = gameConfig.get_value(section, "setVDefaultDisplaySettings")
		setVFullscreen = gameConfig.get_value(section, "setVFullscreen")
		setVDefaultResolutionSettings = gameConfig.get_value(section, "setVDefaultResolutionSettings")
		setVXResolution = gameConfig.get_value(section, "setVXResolution")
		setVYResolution = gameConfig.get_value(section, "setVYResolution")

	# Update UI
	if(!setVDefaultDisplaySettings):
		print("[UI] Set Fullscreen")
		get_node("Settings/Video Settings/Display Settings/FullScreen").set_pressed_no_signal(true)
	if(!setVDefaultResolutionSettings):
		print("[UI] Set Resolution")
		var resSet = false
		for resOptionIndex in range(resolutionOptions.size()):
			var resOption = resolutionOptions[resOptionIndex]
			if (setVXResolution == resOption[0] and setVYResolution == resOption[1]):
				get_node("Settings/Video Settings/Display Settings/ResolutionOptions").select(resOptionIndex+1)
				resSet = true
		if (!resSet):
			get_node("Settings/Video Settings/Display Settings/ResolutionOptions").add_item(str(setVXResolution, "X", setVYResolution), 99)
			var index = get_node("Settings/Video Settings/Display Settings/ResolutionOptions").get_item_index(99)
			get_node("Settings/Video Settings/Display Settings/ResolutionOptions").select(index)
			get_node("Settings/Video Settings/Display Settings/ResolutionOptions").set_item_disabled(index, true)
			
func updateSettings():
	# Game Settings
	
	# Video Settings
	OS.set_window_fullscreen(setVFullscreen)
	if(!setVDefaultResolutionSettings):
		OS.set_window_size(Vector2(setVXResolution, setVYResolution))

	# Audio Settings

func _on_X_pressed():
	get_tree().change_scene("res://Main Menu.tscn")

func _on_FullScreen_toggled(isPressed):
	if (isPressed):
		setVDefaultDisplaySettings = false
		setVFullscreen = true
	else:
		setVDefaultDisplaySettings = true
		setVFullscreen = false
	updateSettings()
	save_settings()
	
# >>> Add Bordless Fullscreen?
# > Seems plauged with issues...
# > See: OS.set_borderless_window(true)
#OS.set_borderless_window(true)
#OS.set_window_size(OS.get_screen_size())
#OS.set_window_position(Vector2(0, 0))


func _on_ResolutionOptions_item_selected(index):
	if (index) == 0:
		setVXResolution = 1280
		setVYResolution = 720
		updateSettings() # temp solution to set an intermediary resolution until game is restarted and default X and Y is in play again
		setVDefaultResolutionSettings = true
	else:
		var selectedResolution = resolutionOptions[index-1]
		setVDefaultResolutionSettings = false
		setVXResolution = selectedResolution[0]
		setVYResolution = selectedResolution[1]
	updateSettings()
	save_settings()

