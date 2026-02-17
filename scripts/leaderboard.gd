extends Control


var time_score = ""
var done: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect/Label2.text = "Score: " + time_score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if done:
		var new_scene = preload("res://scenes/actual_leaderboard.tscn").instantiate()
		new_scene.namey = $ColorRect/TextEdit.text
		new_scene.time = time_score
		get_tree().get_root().add_child(new_scene)
		get_tree().get_root().remove_child(get_tree().current_scene)


func _on_button_pressed() -> void:
	done = true
