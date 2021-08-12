extends Node

const TIME_OFFSET_DEFAULT : int = 0
var time_offset : int

onready var earth_time : Array = []
onready var eorzea_time : Array = get_eorzea_time()


func _process(_delta) -> void:
	earth_time = get_earth_time()
	eorzea_time = get_eorzea_time()

func get_earth_time():
	var localtime = OS.get_time()
	var hour: int = localtime.hour
	var minute: int = localtime.minute
	var second: int = localtime.second
	var am_pm : String = ""
	
	if hour > 13: #Convert to 12 hour time
		hour -= 12
	if hour > 11:
		am_pm = "pm"
	else:
		am_pm = "am"
	return [hour, minute, second, am_pm]


func get_eorzea_time():
	var unix_time : int = OS.get_unix_time()
#	unix_time = unix_time * 720/35 + 28880 + 14400 # correct offset
# warning-ignore:integer_division
	unix_time = unix_time * 3600/175 + (TIME_OFFSET_DEFAULT + time_offset)
#	unix_time = unix_time * 3600/175 + 43000 # Debug
	
	var eorzea_time = OS.get_datetime_from_unix_time(unix_time)
	var hour: int = eorzea_time.hour
	var _24hour: int = eorzea_time.hour
	var minute: int = eorzea_time.minute
	var second: int = eorzea_time.second
	var am_pm: String = ""
	
	if hour == 0:
		hour = 12
	if hour > 12:
		hour -= 12
	
	if _24hour > 11:
		am_pm = "pm"
	else:
		am_pm = "am"
	return [hour, minute, second, am_pm, eorzea_time, _24hour]
