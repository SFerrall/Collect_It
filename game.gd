extends Node2D
@onready var BOARD = $Board

var score : int
var can_flip : bool = true
var current_run : Array[int]
var seconds : float = 180
var running : bool = false

enum STATE {
	DESCENDING,
	ASCENDING,
	MATCHING,
	NONE
}

var state : STATE = STATE.NONE

func _process(delta):
	if seconds > 0 && running:
		seconds -= delta
		update_clock()
	elif seconds <= 0:
		running = false
		can_flip = false
		$AudioStreamPlayer.stop()
		$CanvasLayer/Clock.text = "Time: 0:00"
		$GameOverPanel/VBoxContainer/Label3.text = str(score)
		$GameOverPanel.show()
	
func update_clock() -> void:
	var display_seconds = int(floor(seconds)) % 60
	var minutes = int(floor(seconds/60))
	$CanvasLayer/Clock.text = "Time: " + "%01d" % minutes + ":" + "%02d" % display_seconds

func check_win():
	if len(current_run) > 1:
		match state:
			STATE.MATCHING:
				if BOARD.Board[current_run[-1]].value == BOARD.Board[current_run[-2]].value :
					state = STATE.MATCHING
				else:
					reset()
				
			STATE.ASCENDING:
				if BOARD.Board[current_run[-1]].value  == BOARD.Board[current_run[-2]].value  + 1:
					state = STATE.ASCENDING
				else:
					reset()
			STATE.DESCENDING:
				if BOARD.Board[current_run[-1]].value  + 1 == BOARD.Board[current_run[-2]].value :
					state = STATE.DESCENDING
				else:
					reset()
			STATE.NONE:
				if BOARD.Board[current_run[-1]].level == BOARD.Board[current_run[-2]].level :
					if BOARD.Board[current_run[-1]].value == BOARD.Board[current_run[-2]].value :
						state = STATE.MATCHING
					elif BOARD.Board[current_run[-1]].value  == BOARD.Board[current_run[-2]].value  + 1:
						state = STATE.ASCENDING
					elif BOARD.Board[current_run[-1]].value  + 1 == BOARD.Board[current_run[-2]].value:
						state = STATE.DESCENDING
					else:
						reset()
	

func reset():
	can_flip = false
	state = STATE.NONE
	await get_tree().create_timer(1.0).timeout
	for i in current_run:
		BOARD.Board[i].get_node('Label').text = ''
	current_run.clear()
	can_flip = true

func collect():
	match state:
		STATE.MATCHING:
			var points : int
			for i in current_run:
				points += BOARD.Board[i].value * BOARD.Board[i].level
			points *= len(current_run)
			update_score(points)
			upgrade()
				
		STATE.ASCENDING:
			var points : int
			for i in current_run:
				points += BOARD.Board[i].value * BOARD.Board[i].level
			points *= len(current_run)
			update_score(points)
			upgrade()
			
		STATE.DESCENDING:
			var points : int
			for i in current_run:
				points += BOARD.Board[i].value * BOARD.Board[i].level
			points *= len(current_run)
			update_score(points)
			upgrade()
			
		STATE.NONE:
			reset()
		


func _on_collect_pressed():
	collect()
	
func update_score(points):
	score += points
	$CanvasLayer/HBoxContainer/Score.text = str(score)
	
func upgrade():
	for i in current_run:
		BOARD.Board[i].value = randi() % 10 + 1
		BOARD.Board[i].level += 1
		BOARD.Board[i].get_node('Label').text = ''
		BOARD.Board[i].get_theme_stylebox("normal").border_color = BOARD.Board[i].Colors[BOARD.Board[i].level]
	current_run.clear()
	state = STATE.NONE


func _on_play_again_button_pressed():
	get_tree().reload_current_scene()


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://SCENES/menu.tscn")


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://SCENES/menu.tscn")
