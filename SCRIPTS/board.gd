extends Node2D

@onready var GAME = get_parent()
const CARD : PackedScene = preload("res://SCENES/Card.tscn")

const COLUMNS : int = 10

var Deck : Array[int]
var Board : Array

func _ready():
	$GridContainer.columns = COLUMNS
	load_deck()
	deal()
	
	
	
func deal():
	for col in COLUMNS * COLUMNS:
		var card = CARD.instantiate()
		var value : int = Deck.pop_front()
		card.value = value
		card.index = col
		var stylebox = StyleBoxFlat.new()
		stylebox.border_color = card.Colors[1]
		stylebox.bg_color = Color(0.092, 0.092, 0.092)
		stylebox.set_border_width_all(2)
		card.add_theme_stylebox_override("normal", stylebox)
		Board.append(card)
		card.get_node('Label').text = ""
		$GridContainer.add_child(card)
		await get_tree().create_timer(0.01).timeout
	GAME.running = true

func load_deck():
	for i in range(10):
		for v in range(10):
			Deck.append(v + 1)
	Deck.shuffle()
	print(Deck)
