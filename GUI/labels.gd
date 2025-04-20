extends Label

@export var length: int = 1
var value: int = 5

func _ready() -> void:
	update()

func reset() -> void:
	value = 5
	update()

func adjust(adjustment: int) -> void:
	value += adjustment
	update()

func update() -> void:
	$value.text = ("%0*d" % [length, value])
