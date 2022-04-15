extends Node

enum Modes {PLAYING, BUILDING}
enum Difficulties {EASY, DIFFICULT, IMPOSSIBLE}

const MAX_ROUNDS = 5

var lives = -1
var winTally = [0, 0]

var GM = null
var debugText = null

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

# Gets a random element of an array
func choose(a):
	return a[randi() % a.size()]
