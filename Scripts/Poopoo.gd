extends AudioStreamPlayer

var cool = "neat"
# Called when the node enters the scene tree for the first time.
func _ready():
	cool = randf_range(1, 7)
	if cool == 1:
		stream = load("res://Music/TestingTides/Can't Take It Anymore (Chemical City) - Toree Genesis .mp3")
	if cool == 2:
		stream = load("res://Music/TestingTides/Shangri-La (with Glumboy) - MusicByHydra.mp3")
	if cool == 3:
		stream = load("res://Music/TestingTides/64 BONUS Move It, Boy.mp3")
	if cool == 4:
		stream = load("res://Music/TestingTides/65 BONUS Overcooked Meat Lover.mp3")
	if cool == 5:
		stream = load("res://Music/TestingTides/71 BONUS Move It, Boy.mp3")
	if cool == 6:
		stream = load("res://Music/TestingTides/Gust Planet Act 1 - Sonic 1 The Next Level.mp3")
	if cool == 7:
		stream = load("res://Music/TestingTides/Special Stage - Sonic Mania Megamix.ogg")
	playing = 1
	
