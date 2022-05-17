extends Node

enum Modes {PLAYING, BUILDING}
enum Difficulties {EASY, DIFFICULT, IMPOSSIBLE}

const MAX_ROUNDS = 10

var lives = -1
var winTally = [0, 0]

var playerSprites = [1, 0]
var customSprites = []

var GM = null
var debugText = null
var UI = null

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
	var custom_file = "res://Custom Character Designs/custom%d.png"
	customSprites.append(load(custom_file % 1))
	customSprites.append(load(custom_file % 2))


# Gets a random element of an array
func choose(a):
	return a[rng.randi() % a.size()]
