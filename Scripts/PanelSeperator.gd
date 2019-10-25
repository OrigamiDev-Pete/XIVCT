extends HBoxContainer

#export var separation_factor : int = 60
var screen_size : Vector2 = Vector2()

func _ready():
# warning-ignore:return_value_discarded
	get_viewport().connect("size_changed", self, "_on_size_changed")
	screen_size = OS.window_size
	set_box_size()
	
	
	#Legacy Code
#	var separation = screen_size.x / separation_factor
#	set("custom_constants/separation", separation)



func _on_size_changed():
	screen_size = OS.window_size
	set_box_size()
	
	#Legacy Code
#	var separation = screen_size.x / separation_factor
#	set("custom_constants/separation", separation)

func set_box_size():
	var box_big = screen_size.x / 7
	var box_small = screen_size.x / 15
	var box_tiny = screen_size.x / 19
	
	$Timer.rect_min_size.x = box_big
	if $Timer.rect_min_size.x < 81:
		$Timer.rect_min_size.x = 80
	$ItemName.rect_min_size.x = box_big
	if $ItemName.rect_min_size.x < 101:
		$ItemName.rect_min_size.x = 100
	$Rating.rect_min_size.x = box_small
	if $Rating.rect_min_size.x < 56:
		$Rating.rect_min_size.x = 55
	$Slot.rect_min_size.x = box_tiny
	if $Slot.rect_min_size.x < 35:
		$Slot.rect_min_size.x = 34
	$VBoxContainer2.rect_min_size.x = box_big
	if $VBoxContainer2.rect_min_size.x < 135:
		$VBoxContainer2.rect_min_size.x = 134
	$Scrips.rect_min_size.x = box_small
	if $Scrips.rect_min_size.x < 53:
		$Scrips.rect_min_size.x = 52