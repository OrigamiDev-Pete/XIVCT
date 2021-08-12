extends Control

var new_version
#var auto_update : bool

func _ready():
	SaveLoad.load()
#	if auto_update:
	$HTTPRequest.request("https://greenmoggle.github.io/Versions.json")


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		SaveLoad.save()
		get_tree().quit()


func _on_Button_pressed():
	($ItemSelect as Node).show()


func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		return
	new_version = JSON.parse(body.get_string_from_utf8())
	print(new_version.result)
	if new_version.result["Client"] != DictionaryLoader.versions["Client"]:
		$UpdateLabel.text = "Update Available..."
		$Settings.update_ready = true
		$Settings/Tabs/General/Button.text = "Update"
	if new_version.result["Item"] != DictionaryLoader.versions["Item"]:
		$UpdateLabel.text = "Update Available..."
		$Settings.item_update_ready = true
		$Settings/Tabs/General/Button.text = "Update"


func _on_Update_pressed():
	$HTTPRequest.request("https://greenmoggle.github.io/Versions.json")


func _on_ItemUpdate_request_completed(_result, response_code, _headers, _body):
	if response_code != 200:
		return
	var file = File.new()
	file.open("res://JSON/Versions.json", File.WRITE)
	file.store_string(to_json(new_version.result))
	file.close()

func _on_Overlay_pressed():
	overlay_mode()

func overlay_mode():
	get_tree().call_group("Main", "hide")
	get_tree().call_group("Overlay", "show")
	
	OS.set_window_always_on_top(true)
	OS.window_per_pixel_transparency_enabled = true
	OS.window_borderless = true
	get_tree().get_root().set_transparent_background(true)
	if $OverlayMode.last_position != null:
		OS.window_position = $OverlayMode.last_position
	
	$OverlayMode.add_panels()


func _on_CloseButton_pressed():
	get_tree().call_group("Overlay", "hide")
	get_tree().call_group("Main", "show")
	OS.window_per_pixel_transparency_enabled = false
	get_tree().get_root().set_transparent_background(false)
	OS.window_borderless = false
	OS.set_window_always_on_top(false)
	OS.window_position = OS.get_screen_size()/4
