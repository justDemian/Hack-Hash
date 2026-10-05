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
			maze_row.append("·")
		maze.append(maze_row)

	# Poblate the maze
	for row in range(size):
		for col in range(size):
			poblate(row, col, size)

	for row in range(size):
		print(maze[row])

func poblate(row: int, col: int, size: int) -> void:
	var new_cell: String = "·"
	var posible_cells: Array[String]
	var connections: Array[int] = [0,0,0,0] # up, right, down, left
	# Defining the Starting Point
	if col + row == 0:
		match randi_range(0,2):
			0: new_cell = "→"
			1: new_cell = "↓"
			2: new_cell = "╔"

	# Restriction of the up side of the maze
	elif row == 0:
		if col != size-1:
			connections[1] = evaluate_neighbor(row,col,"right")
		connections[2] = evaluate_neighbor(row,col,"down")
		connections[3] = evaluate_neighbor(row,col,"left")
	
	# Restriction of the down side of the maze
	elif row == size-1:
		connections[0] = evaluate_neighbor(row,col,"up")
		if col != size-1:
			connections[2] = evaluate_neighbor(row,col,"right")
		connections[3] = evaluate_neighbor(row,col,"left")
	
	# Restriction of the left side of the maze
	elif col == 0:
		connections[0] = evaluate_neighbor(row,col,"up")
		connections[1] = evaluate_neighbor(row,col,"right")
		connections[2] = evaluate_neighbor(row,col,"down")
	
	# Restriction of the right side of the maze
	elif col == size-1:
		connections[0] = evaluate_neighbor(row,col,"up")
		connections[2] = evaluate_neighbor(row,col,"down")
		connections[3] = evaluate_neighbor(row,col,"left")
	
	# Unrestricted evaluation in case of the filter didnt catch anything
	else:
		connections[0] = evaluate_neighbor(row,col,"up")
		connections[1] = evaluate_neighbor(row,col,"right")
		connections[2] = evaluate_neighbor(row,col,"down")
		connections[3] = evaluate_neighbor(row,col,"left")
	
	# Asignation of the value of the cell // UP - RIGHT - DOWN - LEFT
	match connections:
		# Arbitrary
		[0,0,0,0]: new_cell = " "
		[0,0,0,1]: new_cell = "→"
		[0,0,1,0]: new_cell = "↑"
		[0,0,1,1]: new_cell = "╗"
		[0,1,0,0]: new_cell = "←"
		[0,1,0,1]: new_cell = "═"
		[0,1,1,0]: new_cell = "╔"
		[0,1,1,1]: new_cell = "╦"
		[1,0,0,0]: new_cell = "↓"
		[1,0,0,1]: new_cell = "╝"
		[1,0,1,0]: new_cell = "║"
		[1,0,1,1]: new_cell = "╣"
		[1,1,0,0]: new_cell = "╚"
		[1,1,0,1]: new_cell = "╩"
		[1,1,1,0]: new_cell = "╠"
		[1,1,1,1]: new_cell = "╬"
		# Pickeables
		[0,0,0,2]: new_cell = "→"
		[0,0,2,0]: new_cell = "↑"
		[0,0,2,2]: posible_cells = ["↑","→","╗"]
		[0,2,0,2]: new_cell = "←"
		[0,2,0,2]: posible_cells = ["→","═","←"]
		[0,2,2,0]: posible_cells = ["←","↑","╔"]
		[0,2,2,2]: posible_cells = ["→","↑","╗","←","═","╔","╦"]
		[2,0,0,0]: new_cell = "↓"
		[2,0,0,2]: posible_cells = ["→","↓","╝"]
		[2,0,2,0]: posible_cells = ["↑","↓","║"]
		[2,0,2,2]: posible_cells = ["→","↑","╗","↓","╝","║","╣"]
		[0,0,0,2]: new_cell = "←"
		[0,0,0,2]: new_cell = "←"
		[0,0,0,2]: new_cell = "←"
		[0,0,0,2]: new_cell = "←"
		[0,0,0,2]: new_cell = "←"
		

# Maze Symbols · → ↑ ╗ ← ═ ╔ ╦ ↓ ╝ ║ ╣ ╚ ╩ ╠ ╬
	
	maze[col][row] = new_cell

func evaluate_neighbor(row: int, col: int,neighbor: String) -> int:
	var neighbor_status: int = 0 # 0:no connection, 1:need connection, 2:open to connection
	if neighbor == "up":
		if maze[row-1][col] == "·":
			neighbor_status = 2
		elif maze[row-1][col] in "╗╔╦↑║╣╠╬":
			neighbor_status = 1
	
	if neighbor == "right":
		if maze[row][col+1] == "·":
			neighbor_status = 2
		elif maze[col][row+1] in "╗→═╦╝╣╩╬":
			neighbor_status = 1
	
	if neighbor == "down":
		if maze[row+1][col] == "·":
			neighbor_status = 2
		elif maze[row+1][col] in "↓╝║╣╚╩╠╬":
			neighbor_status = 1
	
	if neighbor == "left":
		if maze[row][col-1] == "·":
			neighbor_status = 2
		elif maze[row][col-1] in "←═╔╦╚╩╠╬":
			neighbor_status = 1
	
	return neighbor_status
# Maze Symbols · ← ↓ ╗ → ═ ╔ ╦ ↑ ╝ ║ ╣ ╚ ╩ ╠ ╬
