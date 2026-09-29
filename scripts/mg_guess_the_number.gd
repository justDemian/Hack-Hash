extends Node2D

@onready var timer: Timer = $Timer
@onready var timer_bar: ProgressBar = $Control/TimerBar/TimerBarProgress
@onready var timer_bar_label: Label = $Control/TimerBar/TimerBarLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_bar.max_value = timer.wait_time
	timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_bar.value = timer.time_left
	timer_bar_label.text = str(timer.time_left).pad_decimals(1)


func _on_button_1_pressed() -> void:
	pass # Replace with function body.
