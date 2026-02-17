extends Control


var namey = ""
var time = ""
@onready var http1 = $HTTPRequest
@onready var http2 = $HTTPRequest2
var state = ""
var posted = false
var getted = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	http1.request_completed.connect(_on_post)
	http2.request_completed.connect(_on_get)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "":
		var json = JSON.stringify({"name": namey, "time": time})
		var headers = ["Content-Type: application/json"]
		http1.request("https://leaderboard-khbj.onrender.com/score", headers, HTTPClient.METHOD_POST, json)
		state = "1"
	if state == "1":
		if posted:
			state = "2"
	if state == "2":
		http2.request("https://leaderboard-khbj.onrender.com/leaderboard")
		state = "3"
	if state == "3":
		if getted:
			state = "4"
	if state == "4":
		if OS.has_feature('JavaScript'):
			JavaScriptBridge.eval("window.location.href='https://leaderboard-khbj.onrender.com/'")
		else:
			OS.shell_open("https://leaderboard-khbj.onrender.com/")


func _on_post(result, response_code, headers, body):
	posted = true


func _on_get(result, response_code, headers, body):
	getted = true
	var json = JSON.parse_string(body.get_string_from_utf8())
