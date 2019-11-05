extends Panel
# warning-ignore-all:integer_division
signal gatherable
signal complete

onready var itemdic : Dictionary = DictionaryLoader.item_dictionary

onready var colour : Node = $PanelSeparator/ColorRect
onready var timer : Node = $PanelSeparator/Timer
onready var icon : Node = $PanelSeparator/Control/IconBG/Icon
onready var label : Node = $PanelSeparator/ItemName
onready var rating : Node = $PanelSeparator/Rating
onready var slot : Node = $PanelSeparator/Slot
onready var location : Node = $PanelSeparator/VBoxContainer2/Location
onready var crystal : Node = $PanelSeparator/VBoxContainer2/ClosestCrystal
onready var scrips : Node = $PanelSeparator/Scrips
onready var scriptype : Node = $PanelSeparator/ScripType
onready var scriptypeextra : Node = $Extras/Extras/ScripType

var item : String
var regex = RegEx.new()
var offset_factor = 20 # Corrects timers to match earth seconds
var time_offset = 3600 / offset_factor # Converts timers into local time
var audio_played : bool = false
var sort_ready : bool = true
var active : bool = false
var completed : bool = false
var hidden_by : String

onready var item_time : int = itemdic[item]["basic"][1]
onready var item_time2 : int = item_time + 12
onready var life : int = 2
onready var type : String = itemdic[item]["basic"][0]

func _ready():
	get_viewport().connect("size_changed", self, "_on_size_changed")
	
	if itemdic[item]["basic"][0] == "fishingtheme":
		life = itemdic[item]["fish"][0]
	if item == "":
		var current_time = GetClock.eorzea_time
		var current_seconds = (current_time[0] * 3600) + (current_time[1] * 60) + current_time[2]
		var result = current_seconds - 28800
		timer.text = str(result / 60) + ":" + str(result % 60)
		return
	else:
		group(item)
		set_colour(item)
		icon.texture = load(itemdic[item]["basic"][2])
		label.text = itemdic[item]["basic"][3]
		rating.text = itemdic[item]["basic"][4]
		slot.text = itemdic[item]["basic"][5]
		location.text = itemdic[item]["basic"][6]
		crystal.text = itemdic[item]["basic"][7]
		scrips.text = itemdic[item]["basic"][8]
		scrip_colour()
		get_extras(item)
# warning-ignore:return_value_discarded
		connect("gatherable", get_parent(), "_on_gatherable", [self])
		connect("complete", get_parent(), "_on_complete")



func _process(_delta) -> void:
	if item != "":
#		if itemdic[item]["basic"][0] == "fishingtheme":
#			compare_time_fish(item_time, life)
#		else:
#			compare_time(item_time, life)
		compare_time(item_time, life)

func set_colour(item):
	if itemdic[item]["basic"][0] == "miningtheme":
		colour.color = Color("eb9714")
	if itemdic[item]["basic"][0] == "botanytheme":
		colour.color = Color("9cd438")
	if itemdic[item]["basic"][0] == "fishingtheme":
		colour.color = Color("6dcee8")

func scrip_colour():
	if is_in_group("White"):
		scriptype.texture = ResLoader.white
		scriptypeextra.texture = ResLoader.white
	else:
		pass

func _on_searched(hider):
	_hide(hider)

func _on_found(search_text, hider):
	regex.compile("(?i)" + search_text)
	var result = regex.search(item)
	if result:
		_show(hider)

func compare_time(item_time : int, life : int): # Compares 12 hour time
	if not is_in_group("Fishing"):
		var item_end : int = int(item_time) + life
		var current_time : Array = GetClock.eorzea_time
		var current_seconds : int
		if current_time[0] == 1 and item_time == 12:
			item_time -= 12
			item_end -= 12
		current_seconds = (current_time[0] * 3600) + (current_time[1] * 60) + current_time[2]
		var active_time : int = (int(item_time) * time_offset) - current_seconds / 20
		var end_time : int = (item_end * time_offset) - current_seconds / 20


		if itemdic[item]["basic"][1] == 0:
			timer.text = "∞"
			return 0
			
		if active_time > 0:
			timer.text = str(active_time / 60) + ":" + str("%02d" % (active_time % 60))
			audio_played = false
			return active_time
			
			
		elif active_time < 0 and end_time > 0:
			timer.text = str(end_time/ 60) + ":" + str("%02d" % (end_time % 60))
			if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.miniactivestyle:
				set("custom_styles/panel", ResLoader.activestyle)
				$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.miniactivestyle)
				$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.miniactivestyle)
				$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.miniactivestyle)
				
				active = true
			if end_time < 3:
				raise()
				emit_signal("complete")
				if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.minipanelstyle:
					set("custom_styles/panel", ResLoader.panelstyle)
					$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.minipanelstyle)
					$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.minipanelstyle)
					$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.minipanelstyle)
					active = false
			
			if not audio_played:
				emit_signal("gatherable")
				audio_played = true
				get_parent().refresh_sort()
			return 0
			
			
		elif active_time < 0 and end_time < 0:
			var active_time2 = (int(item_time2) * time_offset) - current_seconds / 20
			timer.text = str(active_time2 / 60) + ":" + str("%02d" % (active_time2 % 60))
			if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.minipanelstyle:
				set("custom_styles/panel", ResLoader.panelstyle)
				$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.minipanelstyle)
				$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.minipanelstyle)
				$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.minipanelstyle)
			if sort_ready:
				get_parent().refresh_sort()
				sort_ready = false
				audio_played = false

			return active_time2
	
	else:
		if item_time == 12 and itemdic[item]["fish"][4] == "am":
			item_time -= 12
		var item_end = int(item_time) + life
		var current_time = GetClock.eorzea_time
		var current_seconds = (current_time[5] * 3600) + (current_time[1] * 60) + current_time[2]
		var active_time = (int(item_time) * time_offset) - current_seconds / 20
		var end_time = (item_end * time_offset) - current_seconds / 20
	
		if itemdic[item]["basic"][1] == 0:
			timer.text = "∞"
			return 0
			
		if active_time > 0:
			timer.text = str(active_time / 60) + ":" + str("%02d" % (active_time % 60))
			audio_played = false
			return active_time
			
			
		elif active_time < 0 and end_time > 0: #and itemdic[item]["fish"][4] == current_time[3]:
			timer.text = str(end_time/ 60) + ":" + str("%02d" % (end_time % 60))
			if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.miniactivestyle:
				set("custom_styles/panel", ResLoader.activestyle)
				$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.miniactivestyle)
				$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.miniactivestyle)
				$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.miniactivestyle)
				active = true
			if end_time < 3:
				raise()
				emit_signal("complete")
				if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.minipanelstyle:
					set("custom_styles/panel", ResLoader.panelstyle)
					$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.minipanelstyle)
					$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.minipanelstyle)
					$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.minipanelstyle)
					active = false
			
			if not audio_played:
				emit_signal("gatherable")
				audio_played = true
				get_parent().refresh_sort()
			return 0
		
#		elif active_time < 0 and end_time > 0 and itemdic[item]["fish"][4] != current_time[3]:
#			timer.text = str(end_time/ 60) + ":" + str("%02d" % (end_time % 60))
#			return 0 
		
		elif active_time < 0 and end_time < 0:
			var new_time = item_time + 24
			var active_time2 = (int(new_time) * time_offset) - current_seconds / 20
			timer.text = str(active_time2 / 60) + ":" + str("%02d" % (active_time2 % 60))
			if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.minipanelstyle:
				set("custom_styles/panel", ResLoader.panelstyle)
				$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.minipanelstyle)
				$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.minipanelstyle)
				$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.minipanelstyle)
				get_parent().refresh_sort()
			if sort_ready:
				get_parent().refresh_sort()
				sort_ready = false
				audio_played = false
			return active_time2

#func compare_time(item_time, life = 2): # Compares 12 hour time
#	var item_end = int(item_time) + life
#	var current_time = GetClock.eorzea_time
#	var current_seconds = (current_time[0] * 3600) + (current_time[1] * 60) + current_time[2]
#	var active_time = (int(item_time) * time_offset) - current_seconds / 20
#	var end_time = (item_end * time_offset) - current_seconds / 20
##	print(item_end)
##	print(current_time)
##	print(current_seconds)
##	print(active_time)
##	print(end_time)
#
#	if itemdic[item]["basic"][1] == 0:
#		timer.text = "∞"
#		return 0
#
#	if active_time > 0:
#		timer.text = str(active_time / 60) + ":" + str("%02d" % (active_time % 60))
#		audio_played = false
#		return active_time
#
#
#	elif active_time < 0 and end_time > 0:
#		timer.text = str(end_time/ 60) + ":" + str("%02d" % (end_time % 60))
#		if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.miniactivestyle:
#			set("custom_styles/panel", ResLoader.activestyle)
#			$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.miniactivestyle)
#			$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.miniactivestyle)
#			$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.miniactivestyle)
#			active = true
#		if end_time < 3:
#			raise()
#			if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.minipanelstyle:
#				set("custom_styles/panel", ResLoader.panelstyle)
#				$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.minipanelstyle)
#				$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.minipanelstyle)
#				$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.minipanelstyle)
#				active = false
#
#		if not audio_played:
#			emit_signal("gatherable")
#			audio_played = true
#		return 0
#
##	elif active_time < 0 and end_time < 0:
##		var new_time = item_time + 12
##		var active_time2 = (int(new_time) * time_offset) - current_seconds / 20
##		timer.text = str(active_time2 / 60) + ":" + str("%02d" % (active_time2 % 60))
##		if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.minipanelstyle:
##			set("custom_styles/panel", ResLoader.panelstyle)
##			$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.minipanelstyle)
##			$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.minipanelstyle)
##			$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.minipanelstyle)
##			get_parent().refresh_sort()
##		audio_played = false
##		return active_time2
#
#	elif active_time < 0 and end_time < 0:
#		var active_time2 = (int(item_time2) * time_offset) - current_seconds / 20
#		timer.text = str(active_time2 / 60) + ":" + str("%02d" % (active_time2 % 60))
#		if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.minipanelstyle:
#			set("custom_styles/panel", ResLoader.panelstyle)
#			$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.minipanelstyle)
#			$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.minipanelstyle)
#			$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.minipanelstyle)
#			get_parent().refresh_sort()
#		audio_played = false
#		return active_time2
#
#func compare_time_fish(item_time, life = 0): # Compares 24hour time
#	var item_end = int(item_time) + life
#	var current_time = GetClock.eorzea_time
#	var current_seconds = (current_time[5] * 3600) + (current_time[1] * 60) + current_time[2]
#	var active_time = (int(item_time) * time_offset) - current_seconds / 20
#	var end_time = (item_end * time_offset) - current_seconds / 20
#
#	if itemdic[item]["basic"][1] == 0:
#		timer.text = "∞"
#		return 0
#
#	if active_time > 0:
#		timer.text = str(active_time / 60) + ":" + str("%02d" % (active_time % 60))
#		audio_played = false
#		return active_time
#
#
#	elif active_time < 0 and end_time > 0 and itemdic[item]["fish"][4] == current_time[3]:
#		timer.text = str(end_time/ 60) + ":" + str("%02d" % (end_time % 60))
#		if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.miniactivestyle:
#			set("custom_styles/panel", ResLoader.activestyle)
#			$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.miniactivestyle)
#			$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.miniactivestyle)
#			$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.miniactivestyle)
#			active = true
#
#
#		if end_time < 3:
#			raise()
#			if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.minipanelstyle:
#				set("custom_styles/panel", ResLoader.panelstyle)
#				$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.minipanelstyle)
#				$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.minipanelstyle)
#				$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.minipanelstyle)
#				active = false
#
#
#		if not audio_played:
#			emit_signal("gatherable")
#			audio_played = true
#		return 0
#
#	elif active_time < 0 and end_time < 0:
#		var new_time = item_time + 24
#		var active_time2 = (int(new_time) * time_offset) - current_seconds / 20
#		timer.text = str(active_time2 / 60) + ":" + str("%02d" % (active_time2 % 60))
#		if $PanelSeparator/ItemName.get("custom_styles/normal") != ResLoader.minipanelstyle:
#			set("custom_styles/panel", ResLoader.panelstyle)
#			$PanelSeparator/ItemName.set("custom_styles/normal", ResLoader.minipanelstyle)
#			$PanelSeparator/Slot.set("custom_styles/normal", ResLoader.minipanelstyle)
#			$PanelSeparator/Scrips.set("custom_styles/normal", ResLoader.minipanelstyle)
#		audio_played = false
#		return active_time2
#
#func sort_helper(item_time):
#	var item_end = int(item_time) + life
#	var current_time = GetClock.eorzea_time
#	var current_seconds = (current_time[5] * 3600) + (current_time[1] * 60) + current_time[2]
#	var active_time = (int(item_time) * time_offset) - current_seconds / 20
#	var end_time = (item_end * time_offset) - current_seconds / 20
#
#	if itemdic[item]["basic"][1] == 0:
#		timer.text = "∞"
#		return 0
#
#	if active_time > 0:
#		timer.text = str(active_time / 60) + ":" + str("%02d" % (active_time % 60))
#		audio_played = false
#		return active_time
#
#
#	elif active_time < 0 and end_time > 0: #and itemdic[item]["fish"][4] == current_time[3]:
#		return 0
#
#	elif active_time < 0 and end_time < 0:
#		var new_time = item_time + 24
#		var active_time2 = (int(new_time) * time_offset) - current_seconds / 20
#		var end_time2 = ((item_end + 12) * time_offset) - current_seconds / 20
#		return active_time2

func _on_Button_pressed():
	var closed = Vector2(0, 62)
	var open = Vector2(0, 192)
#	if itemdic[item]["basic"][0] == "fishingtheme":
#		open = Vector2(0, 280)
	if OS.window_size.x > 1366 and is_in_group("Fishing"):
		$Extras.set_columns(2)
	elif OS.window_size.x < 1366 and is_in_group("Fishing"):
		open = Vector2(0, 290)
		$Extras.set_columns(1)
	if rect_min_size == closed:
		if is_in_group("Fishing"):
			$Extras/Fish.show()
		$Extras/Extras.show()
		$Extras/Tween.interpolate_property(self, "rect_min_size", null, open , 0.2, Tween.TRANS_QUAD,Tween.EASE_OUT)
		$Extras/Tween.start()
	else:
		$Extras/Fish.hide()
		$Extras/Extras.hide()
		$Extras/Tween.interpolate_property(self, "rect_min_size", null, closed , 0.2, Tween.TRANS_QUAD,Tween.EASE_OUT)
		$Extras/Tween.start()

func get_extras(item):
	if is_in_group("Fishing"):
		$Extras/Fish/Fish/HBoxContainer/Panel2/TextScrollBox/Label.text = itemdic[item]["fish"][1] #Bait
		$Extras/Fish/Fish/HBoxContainer/Panel3/Label.text = itemdic[item]["fish"][2] #Prime Location
		$Extras/Fish/Fish/HBoxContainer/Panel/Label.text = itemdic[item]["fish"][3] #Conditions
		
		$Extras/Fish/Mooch/Mooch/Label.text = itemdic[item]["mooch"][0]
		if itemdic[item]["mooch"][1] == "-":
			$Extras/Fish/Mooch/Mooch/IconBG/Icon.hide()
			$Extras/Fish/Mooch/Mooch/IconBG/HQOverlay.hide()
		else:
			$Extras/Fish/Mooch/Mooch/IconBG/Icon.texture = load(itemdic[item]["mooch"][1])
			$Extras/Fish/Mooch/Mooch/IconBG/Icon.set_tooltip(itemdic[item]["mooch"][2])

	$Extras/Extras/HBoxContainer/Rating/Label2.text = itemdic[item]["adv"][0]
	$Extras/Extras/HBoxContainer/Rating/Label3.text = itemdic[item]["adv"][1]
	$Extras/Extras/HBoxContainer/Rating/Label4.text = itemdic[item]["adv"][2]
	
	$Extras/Extras/HBoxContainer/Scrips/Label2.text = itemdic[item]["adv"][3]
	$Extras/Extras/HBoxContainer/Scrips/Label3.text = itemdic[item]["adv"][4]
	$Extras/Extras/HBoxContainer/Scrips/Label4.text = itemdic[item]["adv"][5]
	
	$Extras/Extras/HBoxContainer/Exp/Label2.text = itemdic[item]["adv"][6]
	$Extras/Extras/HBoxContainer/Exp/Label3.text = itemdic[item]["adv"][7]
	$Extras/Extras/HBoxContainer/Exp/Label4.text = itemdic[item]["adv"][8]
	

func _on_size_changed():
	if is_in_group("Fishing") and $Extras/Extras.visible:
		if OS.window_size.x < 1366 and $Extras.columns != 1:
			$Extras.set_columns(1)
			$Extras/Tween.interpolate_property(self, "rect_min_size", null, Vector2(0, 290) , 0.2, Tween.TRANS_QUAD,Tween.EASE_OUT)
			$Extras/Tween.start()
		elif OS.window_size.x > 1366 and $Extras.columns != 2:
			$Extras.set_columns(2)
			$Extras/Tween.interpolate_property(self, "rect_min_size", null, Vector2(0, 192) , 0.2, Tween.TRANS_QUAD,Tween.EASE_OUT)
			$Extras/Tween.start()

func group(item):
	if itemdic[item]["basic"][0] == "miningtheme":
		add_to_group("Mining", true)
	if itemdic[item]["basic"][0] == "botanytheme":
		add_to_group("Botany", true)
	if itemdic[item]["basic"][0] == "fishingtheme":
		add_to_group("Fishing", true)
	
	if itemdic[item]["basic"][9] == "white":
		add_to_group("White", true)
	if itemdic[item]["basic"][9] == "yellow":
		add_to_group("Yellow", true)

func _hide(hider):
	if hidden_by.empty():
		hidden_by = hider
	hide()

func _show(hider):
	if hider == hidden_by:
		show()
		hidden_by.erase(0, 20)
	else:
		return