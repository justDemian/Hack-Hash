extends Node2D

@onready var timer: Timer = $Timer
@onready var timer_bar: ProgressBar = $Control/TimerBar/TimerBarProgress
@onready var timer_bar_label: Label = $Control/TimerBar/TimerBarLabel

@onready var info_label: Label = $Control/Info/CenterContainer/InfoLabel

@onready var num_0: Label = $Control/NumberPanel/CenterContainer/HBoxContainer/Num0
@onready var num_1: Label = $Control/NumberPanel/CenterContainer/HBoxContainer/Num1
@onready var num_2: Label = $Control/NumberPanel/CenterContainer/HBoxContainer/Num2
@onready var num_3: Label = $Control/NumberPanel/CenterContainer/HBoxContainer/Num3

@onready var labels: Array[Label] = [num_0, num_1, num_2, num_3]

var number_position: int = 0
var password: String
var ram_level: int = 0
var password_num: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	password_num = randi_range(0, 9999)
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
	
	print("Iniciado :: Número secreto [" + password + "]")
	
	timer_bar.max_value = timer.wait_time
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_bar.value = timer.time_left
	timer_bar_label.text = str(timer.time_left).pad_decimals(1)

func evaluate() -> void:
	var guess: String = ""
	if ram_level:
		pass
	else:
		for i in range(4):
			guess += labels[i].text 
	if int(guess) < password_num:
		info_label.text = "LA CLAVE ES MAYOR"
		info_label.add_theme_color_override("font_color", Color("#00AAAA"))
	elif int(guess) > password_num:
		info_label.text = "LA CLAVE ES MENOR"
		info_label.add_theme_color_override("font_color", Color("#AA00AA"))
	else:
		info_label.text = "MATCH :: INICIANDO SOBREESCRITURA"
		info_label.add_theme_color_override("font_color", Color("#00AA00"))

# Numerical Button Handler
func handle_button_press(entry_type: String) -> void:
	if number_position <= 3:
		labels[number_position].text = entry_type
		if number_position != 3: number_position += 1
		else: number_position = 0

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
