extends Node2D


var time = 0
@onready var time_label = $Control/Time
@onready var mc = $AltarServer
var setting = "sanctuary"
var change_setting: bool = false
var genuflect: bool = false
var altar_todo = ["missal", "crucifix", "chalice"]
var credence_todo = ["lavabo"]
var shelf_todo = ["monstrance"]
var candle_hook_todo = ["lighter"]
var counter_todo = ["candles"]
var zone: String = ""
var checklist: int = 0 #End condition -> checklist == 7
var stop: bool = false
var sink
var door
var counter
var shelf
var candle_hook

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BGMusic.play()
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$MobileButtons.visible = true
	sanctuary()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Sacristy2/Sink.overlaps_body(mc):
		sink = true
	else:
		sink = false
	if $Sacristy2/Door.overlaps_body(mc):
		door = true
	else:
		door = false
	if $Sacristy2/Counter.overlaps_body(mc):
		counter = true
	else:
		counter = false
	if $Sacristy2/Shelf.overlaps_body(mc):
		shelf = true
	else:
		shelf = false
	if $Sacristy2/CandleHook.overlaps_body(mc):
		candle_hook = true
	else:
		candle_hook = false
	if !stop:
		time += delta
		time_label.text = "%.3f" % time
	if (zone != "" or sink or counter or shelf or candle_hook) and !door:
		if Input.is_action_just_pressed("ui_accept"):
			$PickUp.play()
			if zone == "altar":
				if mc.inventory == "":
					var temp = altar_todo.pop_front()
					if temp != null:
						mc.inventory = temp
						if temp == "missal":
							$Sanctuary/Altar/Missal.visible = false
						elif temp == "crucifix":
							$Sanctuary/Altar/AltarCrucifix.visible = false
						elif temp == "chalice":
							$Sanctuary/Altar/DressedChalice.visible = false
					else:
						pass
				elif mc.inventory == "monstrance":
					$Sanctuary/Altar/Monstrance.visible = true
					mc.inventory = ""
					checklist += 1
				elif mc.inventory == "candles":
					$Sanctuary/Altar/AltarCandle1.visible = true
					$Sanctuary/Altar/AltarCandle2.visible = true
					$Sanctuary/Altar/AltarCandle1.play("unlit")
					$Sanctuary/Altar/AltarCandle2.play("unlit")
					mc.inventory = ""
					checklist += 1
				elif mc.inventory == "lighter":
					$Sanctuary/Altar/AltarCandle1.play("lit")
					$Sanctuary/Altar/AltarCandle2.play("lit")
					mc.inventory = "lighter-done"
				else:
					pass
			elif zone == "credence":
				if mc.inventory == "":
					var temp = credence_todo.pop_front()
					if temp != null:
						mc.inventory = temp
						if temp == "lavabo":
							$Sanctuary/Lavabo.visible = false
						else:
							pass
					else:
						pass
				elif mc.inventory == "lavabo-empty":
					$Sanctuary/Lavabo.visible = true
					mc.inventory = ""
					checklist += 1
				else:
					pass
			elif zone == "chair":
				if mc.inventory == "missal":
					mc.inventory = ""
					$Sanctuary/Missal.visible = true
					checklist += 1
				else:
					pass
			elif sink:
				if mc.inventory == "lavabo":
					mc.inventory = "lavabo-empty"
				else:
					pass
			elif counter:
				if mc.inventory == "":
					var temp = counter_todo.pop_front()
					if temp != null:
						mc.inventory = temp
						if temp == "candles":
							$Sacristy2/AltarCandle3.visible = false
							$Sacristy2/AltarCandle4.visible = false
						else:
							pass
					else:
						pass
				elif mc.inventory == "crucifix":
					mc.inventory = ""
					$Sacristy2/AltarCrucifix.visible = true
					checklist += 1
				elif mc.inventory == "chalice":
					mc.inventory = ""
					$Sacristy2/DressedChalice.visible = true
					checklist += 1
				else:
					pass
			elif shelf:
				if mc.inventory == "":
					var temp = shelf_todo.pop_front()
					if temp != null:
						mc.inventory = temp
						if temp == "monstrance":
							$Sacristy2/Monstrance.visible = false
						else:
							pass
					else:
						pass
				else:
					pass
			elif candle_hook:
				if mc.inventory == "" and len(counter_todo) == 0:
					var temp = candle_hook_todo.pop_front()
					if temp != null:
						mc.inventory = temp
						if temp == "lighter":
							$Sacristy2/CandleLighter.visible = false
						else:
							pass
					else:
						pass
				elif mc.inventory == "lighter-done":
					mc.inventory = ""
					$Sacristy2/CandleLighter.visible = true
					checklist += 1
				else:
					pass
			else:
				pass
		else:
			pass
	else:
		if setting == "sanctuary":
			sanctuary()
			if change_setting and Input.is_action_just_pressed("ui_accept"):
				change_setting = false
				setting = "sacristy"
				mc.global_position = Vector2(1000, 300)
				$Enter.play()
		else:
			sacristy()
			if change_setting and Input.is_action_just_pressed("ui_accept"):
				change_setting = false
				setting = "sanctuary"
				mc.global_position = Vector2(165, 491)
				$Enter.play()
	if checklist == 7:
		stop = true
		mc.stop = true
		var new_scene = preload("res://scenes/leaderboard.tscn").instantiate()
		new_scene.time_score = "%.3f" % time
		get_tree().get_root().add_child(new_scene)
		get_tree().get_root().remove_child(get_tree().current_scene)


func sacristy():
	$Sanctuary.visible = false
	$Sanctuary.process_mode = Node.PROCESS_MODE_DISABLED
	$Sacristy2.visible = true
	$Sacristy2.process_mode = Node.PROCESS_MODE_ALWAYS


func sanctuary():
	$Sanctuary.visible = true
	$Sanctuary.process_mode = Node.PROCESS_MODE_ALWAYS
	$Sacristy2.visible = false
	$Sacristy2.process_mode = Node.PROCESS_MODE_DISABLED


func _on_sacristy_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		change_setting = true


func _on_door_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		change_setting = true


func _on_genuflect_genuflect() -> void:
	genuflect = true


func _on_altar_table_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		zone = "altar"


func _on_altar_table_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		zone = ""


func _on_credence_table_2_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		zone = "credence"


func _on_credence_table_2_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		zone = ""


func _on_chair_2_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		zone = "chair"


func _on_chair_2_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		zone = ""


#func _on_sink_body_entered(body: Node2D) -> void:
	#if body.name == "AltarServer":
		#zone = "sink"
#
#
##func _on_sink_body_exited(body: Node2D) -> void:
	##if body.name == "AltarServer":
		##zone = ""
#
#
#func _on_counter_body_entered(body: Node2D) -> void:
	#if body.name == "AltarServer":
		#zone = "counter"
#
#
##func _on_counter_body_exited(body: Node2D) -> void:
	##if body.name == "AltarServer":
		##zone = ""
#
#
#func _on_shelf_body_entered(body: Node2D) -> void:
	#if body.name == "AltarServer":
		#zone = "shelf"
#
#
##func _on_shelf_body_exited(body: Node2D) -> void:
	##if body.name == "AltarServer":
		##zone = ""
#
#
#func _on_candle_hook_body_entered(body: Node2D) -> void:
	#if body.name == "AltarServer":
		#zone = "candle-hook"
#
#
##func _on_candle_hook_body_exited(body: Node2D) -> void:
	##if body.name == "AltarServer":
		##zone = ""
