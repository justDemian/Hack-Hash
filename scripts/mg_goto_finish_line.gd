extends Node2D

@onready var move_1: Button = $Control/Moves/GridContainer/Move1
@onready var move_2: Button = $Control/Moves/GridContainer/Move2
@onready var move_3: Button = $Control/Moves/GridContainer/Move3
@onready var move_4: Button = $Control/Moves/GridContainer/Move4
@onready var move_5: Button = $Control/Moves/GridContainer/Move5
@onready var move_6: Button = $Control/Moves/GridContainer/Move6
@onready var move_7: Button = $Control/Moves/GridContainer/Move7
@onready var move_8: Button = $Control/Moves/GridContainer/Move8
@onready var move_9: Button = $Control/Moves/GridContainer/Move9

@onready var time_left_bar: ProgressBar = $Control/CenterContainer/TimeLeftBar
@onready var time_left_label: Label = $Control/CenterContainer/TimeLeftLabel
@onready var timer: Timer = $Timer

var maze: Array[Array]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_left_bar.max_value = timer.wait_time
	timer.start()
	generate_maze()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_left_label.text = str(timer.time_left).pad_decimals(1)

func generate_maze(size: int = 8) -> void:
	# Creating the Space
	for i in range(size):
		var maze_row: Array[String]
		for j in range(size):
			maze_row.append("n")
		maze.append(maze_row)

	# Poblate the maze
	for row in range(size):
		for col in range(size):
			poblate(row, col, size)

	for col in range(size):
		print(maze[col])

func poblate(row: int, col: int, size: int) -> void:
	var new_cell: String = "n"
	var posible_cells: Array[String]
	# Defining the Starting Point
	if col + row == 0:
		match randi_range(0,2):
			0: new_cell = "0"
			1: new_cell = "1"
			2: new_cell = "4"

	# First row Restriction evaluate x-1, x+1, y-1
	elif row == 0:
		evaluate_neighbor(row, col, "left", posible_cells)
		pass
	
	maze[col][row] = new_cell

func evaluate_neighbor(row: int, col: int,neighbor: String, cell_list: Array[String]) -> void:
	
	pass
