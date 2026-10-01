extends Node2D
@onready var game_over_screen: Control = $GameOver

@onready var timer: Timer = $Timer
@onready var timer_bar: ProgressBar = $Control/TimerBar/TimerBarProgress
@onready var timer_bar_label: Label = $Control/TimerBar/TimerBarLabel
@onready var timer_to_show_victory: Timer = $Control/TimerToShowVictory

@onready var info_label: Label = $Control/Info/CenterContainer/InfoLabel

@onready var num_0: Label = $Control/NumberPanel/CenterContainer/VBoxContainer/HBoxContainer/Num0
@onready var num_1: Label = $Control/NumberPanel/CenterContainer/VBoxContainer/HBoxContainer/Num1
@onready var num_2: Label = $Control/NumberPanel/CenterContainer/VBoxContainer/HBoxContainer/Num2
@onready var num_3: Label = $Control/NumberPanel/CenterContainer/VBoxContainer/HBoxContainer/Num3

@onready var labels: Array[Label] = [num_0, num_1, num_2, num_3]

@onready var last_num_0: Label = $Control/NumberPanel/CenterContainer/VBoxContainer/HBoxContainer2/LastNum0
@onready var last_num_1: Label = $Control/NumberPanel/CenterContainer/VBoxContainer/HBoxContainer2/LastNum1
@onready var last_num_2: Label = $Control/NumberPanel/CenterContainer/VBoxContainer/HBoxContainer2/LastNum2
@onready var last_num_3: Label = $Control/NumberPanel/CenterContainer/VBoxContainer/HBoxContainer2/LastNum3

@onready var labels_last: Array[Label] = [last_num_0, last_num_1, last_num_2, last_num_3]

var difficulty: int = 1

var number_position: int = 0
var password: String
var ram_level: int = 0
var password_num: int
var punishable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	password_num = randi_range(0, 9999)
	# DEBUG
	print(password_num)
	if password_num == 0: 
		password = "0000"
	elif password_num < 10:
		password = "000" + str(password_num)
	elif password_num < 100:
		password = "00" + str(password_num)
	elif password_num < 1000:
		password = "0" + str(password_num)
	elif password_num >= 1000:
		password = str(password_num)
	
	info_label.text = ""
	update_labels_state()
	timer_bar.max_value = timer.wait_time
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_bar.value = timer.time_left
	timer_bar_label.text = str(timer.time_left).pad_decimals(1)

func evaluate() -> void:
	if !punishable:return
	
	var guess: String = ""
	var guess_num: int
	number_position = 0
	if ram_level:
		pass
	else:
		for i in range(4):
			guess += labels[i].text
			labels_last[i].text = labels[i].text
			labels[i].text = "-"
	
	guess_num = int(guess)
	
	if guess_num < password_num:
		info_label.text = "LA CLAVE ES MAYOR"
		info_label.add_theme_color_override("font_color", Color("#00AAAA"))
		punish()
	elif guess_num > password_num:
		info_label.text = "LA CLAVE ES MENOR"
		info_label.add_theme_color_override("font_color", Color("#AA00AA"))
		punish()
	else:
		info_label.text = "MATCH :: INICIANDO SOBREESCRITURA"
		info_label.add_theme_color_override("font_color", Color("#00AA00"))
		game_over(false)

	punishable = false
	update_labels_state()

func update_labels_state() -> void:
	for i in range(4):
		if i == number_position:
			labels[i].add_theme_color_override("font_color", Color("#FFFFFF"))
		else:
			labels[i].add_theme_color_override("font_color", Color("#555555"))

func clean_guess() -> void:
	number_position = 0
	for i in range(4):
		labels[i].text = "-"
	update_labels_state()

func punish() -> void:
	if punishable:
		var punish_value: float = randf_range(0,(timer.time_left/5))*difficulty/2
		# DEBUG
		#print("Castigo: " + str(punish_value).pad_decimals(2) + "s")
		timer.wait_time = timer.time_left - punish_value
		timer.start()

func game_over(status: bool) -> void:
	if status:
		game_over_screen.show()
	else:
		timer_to_show_victory.start()

# Numerical Button Handler
func handle_button_press(entry_type: String) -> void:
	punishable = true
	if number_position <= 3:
		labels[number_position].text = entry_type
		if number_position != 3: number_position += 1
		else: number_position = 0
	update_labels_state()

func _on_button_1_pressed() -> void: handle_button_press("1")
func _on_button_2_pressed() -> void: handle_button_press("2")
func _on_button_3_pressed() -> void: handle_button_press("3")
func _on_button_4_pressed() -> void: handle_button_press("4")
func _on_button_5_pressed() -> void: handle_button_press("5")
func _on_button_6_pressed() -> void: handle_button_press("6")
func _on_button_7_pressed() -> void: handle_button_press("7")
func _on_button_8_pressed() -> void: handle_button_press("8")
func _on_button_9_pressed() -> void: handle_button_press("9")
func _on_button_0_pressed() -> void: handle_button_press("0")

func _on_button_a_pressed() -> void: evaluate()

func _on_clear_pressed() -> void: clean_guess()

func _on_timer_timeout() -> void: game_over(true)

func _on_restart_pressed() -> void: get_tree().reload_current_scene()

func _on_timer_to_show_victory_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
