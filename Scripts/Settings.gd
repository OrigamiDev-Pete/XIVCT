extends Control

var item_update_ready : bool = false
var update_ready : bool = false

var sounds : Array = ["res://Sound/Drum.ogg", "res://Sound/Piano1.ogg", "res://Sound/Piano2.ogg", "res://Sound/Guitar.ogg", "res://Sound/Triangle.ogg","res://Sound/Beep.wav"]
var current_sound : String = "res://Sound/Drum.ogg"
var sound_name : String = "Drum"
var volume : float = -4
var slider_value : float = 0.8

func _ready():
	current_sound = "res://Sound/Drum.ogg"
	$Tabs/General/MenuButton.text = sound_name
	$Tabs/General/HSlider.value = slider_value
	$AudioStreamPlayer.volume_db = volume
	$AudioStreamPlayer.set_stream(load(current_sound))
	get_parent().get_node("AudioStreamPlayer").set_stream(load(current_sound))
	$Tabs/General/MenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed")
	
	$Tabs/General/Version.text = "App Version " + DictionaryLoader.versions["Client"]
	$Tabs/General/Item_Version.text = "Item Version " + DictionaryLoader.versions["Item"] + " accurate to FFXIV " + DictionaryLoader.versions["FF"]


func _on_PlayButton_pressed():
	$AudioStreamPlayer.play()

func _on_item_pressed(id):
	$AudioStreamPlayer.set_stream(load(sounds[id]))
	get_parent().get_node("AudioStreamPlayer").set_stream(load(sounds[id]))
	current_sound = sounds[id]
	sound_name = $Tabs/General/MenuButton.get_popup().get_item_text(id)


func _on_HSlider_value_changed(value):
	$AudioStreamPlayer.volume_db = log(value) * 20
	slider_value = value


func _on_SettingsButton_pressed():
	show()


func _on_Blur_focus_entered():
	hide()

func save():
	return [current_sound, slider_value, sound_name, GetClock.time_offset, $Tabs/General/SoundMinimized/OptionButton.selected, $Tabs/Overlay/HiddenSound/OptionButton.selected]

func load():
	#General Settings
	current_sound = SaveLoad.settings[0]
	volume = log(SaveLoad.settings[1]) * 20
	sound_name = SaveLoad.settings[2]
	$AudioStreamPlayer.volume_db = volume
	$AudioStreamPlayer.set_stream(load(current_sound))
	get_parent().get_node("AudioStreamPlayer").set_stream(load(current_sound))
	get_parent().get_node("AudioStreamPlayer").current_volume = log(SaveLoad.settings[1]) * 20
	$Tabs/General/SoundMinimized/OptionButton.selected = SaveLoad.settings[4]
	$Tabs/Overlay/HiddenSound/OptionButton.selected = SaveLoad.settings[5]
	$Tabs/General/MenuButton.text = sound_name
	$Tabs/General/HSlider.value = SaveLoad.settings[1]
	GetClock.time_offset = int(SaveLoad.settings[3])
	$Tabs/General/Offset/OptionButton.value = GetClock.time_offset
	
	
	#Overlay Settings
	$Tabs/Overlay/Opacity/SpinBox.value = SaveLoad.overlay[2]
	$Tabs/Overlay/Visible/SpinBox.value = SaveLoad.overlay[1]
	$Tabs/Overlay/CloseButton/OptionButton.select(SaveLoad.overlay[3])


func _on_Update_pressed():
	if update_ready:
#		$Update.request()
		pass
	if item_update_ready:
# warning-ignore:return_value_discarded
		($ItemUpdate as HTTPRequest).request("https://greenmoggle.github.io/ItemDictionary.json")
		$Tabs/General/Updater.show()
		$Tabs/General/Updater/Panel/ProgressBar.value = ($ItemUpdate.get_downloaded_bytes()*100/$ItemUpdate.get_body_size())
	else:
		$Tabs/General/Panel2.show()



func _on_ItemUpdate_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		return
	var json = JSON.parse(body.get_string_from_utf8())
	var file = File.new()
	file.open("res://JSON/ItemDictionary.json", File.WRITE)
	file.store_string(to_json(json.result))
	file.close()
	item_update_ready = false
	$Tabs/General/Button.text = "Check for Updates"
	get_node("../UpdateLabel").text = "Restart required"
	$Tabs/General/Updater.hide()
	
	var save_state = File.new()
	if save_state.file_exists():
		var dir = Directory.new()
		dir.remove("res://savestate.save")


func _on_Update_request_completed(_result, response_code, _headers, _body):
	if response_code != 200:
		return


func _on_Close_pressed():
	$Tabs/General/Panel2.hide()


func _on_TimeOffset_value_changed(value):
	GetClock.time_offset = int(value)
	print(GetClock.time_offset)

