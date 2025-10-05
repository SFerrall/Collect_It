extends Button

@onready var GAME = $"../../../"
@onready var BOARD = $"../../"

var value : int 
var index : int
var level : int = 1

var Colors : Dictionary = {
	1: Color(0.0,1.0, 1.0), #Color(0.071,0.714, 0.757),
	2: Color(1,0,0), #Red
	3: Color(1.0, 0.5, 0.0), #Orange
	4: Color(0.0, 1.0, 0.0), #Green
	5: Color(0.0, 0.0, 1.0), #Blue
	6: Color(0.75, 0.0, 0.75), #Purple
	7: Color(1.0, 1.0, 0.0), #Yellow
	8: Color(1.0, 0.5, 0.75), #Pink
	9: Color(0.0, 0.5, 0.0), #Dark Green
	10: Color(0.75, 0.0, 1.0), #Indigo
}

func _ready():
	#self.theme_overrides.styles.normal.border_color = Color(1,0,0)
	#self.get_theme_stylebox("normal").border_color = Color(1,0,0)
	pass


func _on_pressed():
	if GAME.can_flip:
		print(len(GAME.current_run))
		print('level' + str(level))
		if len($Label.text) > 0:
			$Label.text = ''
			GAME.current_run.clear()
			
		else:
			if len(GAME.current_run) == 0:
				$Label.text = str(value)
				GAME.current_run.append(index)
				GAME.check_win()
			elif len(GAME.current_run) == 1 && BOARD.Board[GAME.current_run[-1]].level == level :		
				$Label.text = str(value)
				GAME.current_run.append(index)
				GAME.check_win()
				print('allowed')
			elif len(GAME.current_run) == 2 && BOARD.Board[GAME.current_run[-1]].level == level or len(GAME.current_run) == 2 && BOARD.Board[GAME.current_run[-1]].level + 1 == level :		
				$Label.text = str(value)
				GAME.current_run.append(index)
				GAME.check_win()
				print('allowed2')
			elif len(GAME.current_run) > 2 && BOARD.Board[GAME.current_run[-1]].level == level or len(GAME.current_run) > 2 && BOARD.Board[GAME.current_run[-1]].level + 1 == level : 
				print("len" + str(len(GAME.current_run)))
				$Label.text = str(value)
				GAME.current_run.append(index)
				GAME.check_win()
				print('allowed3')
			else:
				print('nope')
				#$Label.text = str(value)
				#GAME.current_run.append(index)
				#GAME.check_win()
	
