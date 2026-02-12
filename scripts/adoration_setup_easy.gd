extends Node2D


@onready var chara: AltarServer = $AltarServer
@onready var dialogue: Label = $Control/ColorRect2/Label
@onready var fr_jose_ico: TextureRect = $Control/ColorRect2/TextureRect
@onready var pick = $PickUp
@onready var enter = $Enter
@onready var kneel = $Kneel
@onready var mobile = $MobileButtons
var state: String
var awaiting_father: bool = false
var genuflect: bool = false
var credence: bool = false
var sacristy: bool = false
var sink: bool = false
var door: bool = false
var altar: bool = false
var chair: bool = false
var counter: bool = false
var shelf: bool = false
var candle_hook: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		mobile.visible = true
	$Sanctuary.visible = true
	$Sanctuary.process_mode = Node.PROCESS_MODE_ALWAYS
	$Sacristy.visible = false
	$Sacristy.process_mode = Node.PROCESS_MODE_DISABLED
	$Control/ColorRect.visible = false
	state = "start1"
	$BGMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "start1":
		if genuflect:
			state = "genuflect1"
	elif state == "genuflect1":
		dialogue.text = "Press G to genuflect in front of the tabernacle."
		if chara.genuflected:
			kneel.play()
			state = "start2"
			genuflect = false
	elif state == "start2":
		dialogue.text = "Go to Father Jose for further instructions."
		if awaiting_father:
			state = "father1"
	elif state == "father1":
		fr_jose_ico.visible = true
		dialogue.text = "Father Jose: To start setting up for adoration, first get the lavabo bowl and empty out the water in the sacristy's sink."
		if !awaiting_father:
			state = "lavabo1"
			chara.genuflected = false
	elif state == "lavabo1":
		fr_jose_ico.visible = false
		dialogue.text = "Get the lavabo bowl and empty out the water in the sink in the sacristy."
		if genuflect:
			state = "genuflect2"
	elif state == "genuflect2":
		dialogue.text = "Genuflect in front of the tabernacle."
		if chara.genuflected:
			kneel.play()
			state = "lavabo2"
			genuflect = false
	elif state == "lavabo2":
		dialogue.text = "Get the lavabo bowl and empty out the water in the sink in the sacristy."
		if credence:
			state = "lavabo3"
	elif state == "lavabo3":
		dialogue.text = "Press ENTER to pick up lavabo bowl."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			state = "lavabo4"
			chara.inventory = "lavabo"
			$Sanctuary/Lavabo.visible = false
			$Control/ColorRect.visible = true
			$Control/ColorRect/Label.text = "Lavabo Bowl: A bowl used to collect the water from washing the celebrant's hand."
			$Control/ColorRect/TextureRect.texture = load("res://sprites/lavabo.png")
	elif state == "lavabo4":
		dialogue.text = "Go into the sacristy to empty out the lavabo bowl."
		if sacristy:
			state = "lavabo5"
	elif state == "lavabo5":
		dialogue.text = "Press ENTER to go into the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "lavabo6"
			$Sanctuary.visible = false 
			$Sanctuary.process_mode = Node.PROCESS_MODE_DISABLED
			$Sacristy.visible = true
			$Sacristy.process_mode = Node.PROCESS_MODE_ALWAYS
			chara.global_position = Vector2(1000, 300)
			sacristy = false
	elif state == "lavabo6":
		dialogue.text = "Empty the lavabo bowl into the sink."
		if sink:
			state = "lavabo7"
	elif state == "lavabo7":
		dialogue.text = "Press ENTER to empty the lavabo bowl."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			state = "lavabo8"
	elif state == "lavabo8":
		dialogue.text = "Place the lavabo bowl back on the credence table."
		if door:
			state = "lavabo9"
	elif state == "lavabo9":
		dialogue.text = "Press ENTER to exit the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "lavabo10"
			chara.global_position = Vector2(165, 491)
			$Sanctuary.visible = true 
			$Sanctuary.process_mode = Node.PROCESS_MODE_ALWAYS
			$Sacristy.visible = false
			$Sacristy.process_mode = Node.PROCESS_MODE_DISABLED
			door = false
	elif state == "lavabo10":
		dialogue.text = "Place the lavabo bowl back on the credence table."
		if credence:
			state = "lavabo11"
	elif state == "lavabo11":
		dialogue.text = "Press ENTER to place the lavabo bowl back onto the credence table."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			$Control/ColorRect.visible = false
			$Control/ColorRect/Label.text = ""
			state = "father2"
			chara.inventory = ""
			$Sanctuary/Lavabo.visible = true
			chara.genuflected = false
	elif state == "father2":
		dialogue.text = "Go to Father Jose for further instructions."
		if genuflect:
			state = "genuflect3"
	elif state == "genuflect3":
		dialogue.text = "Genuflect in front of the tabernacle."
		if chara.genuflected:
			kneel.play()
			state = "father3"
			genuflect = false
	elif state == "father3":
		dialogue.text = "Go to Father Jose for further instructions."
		if awaiting_father:
			state = "father4"
	elif state == "father4":
		fr_jose_ico.visible = true
		dialogue.text = "Father Jose: Now, take the missal and place it on the chair next to me."
		if !awaiting_father:
			state = "missal1"
	elif state == "missal1":
		fr_jose_ico.visible = false
		dialogue.text = "Take the missal and place it on the chair next to Father Jose."
		chara.inventory = "m"
		if altar:
			state = "missal2"
	elif state == "missal2":
		dialogue.text = "Press ENTER to pick up the missal."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			state = "missal3"
			chara.inventory = "missal"
			$Sanctuary/Altar/Missal.visible = false
			$Control/ColorRect.visible = true
			$Control/ColorRect/Label.text = "Missal: A liturgical book that contains the instructions for the Mass."
			$Control/ColorRect/TextureRect.texture = load("res://sprites/missal-book.png")
	elif state == "missal3":
		dialogue.text = "Place the missal onto the chair next to Father Jose."
		if chair:
			state = "missal4"
	elif state == "missal4":
		dialogue.text = "Press ENTER to place the missal onto the chair."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			state = "father5"
			$Control/ColorRect.visible = false
			$Control/ColorRect/Label.text = ""
			$Sanctuary/Missal.visible = true
			chara.inventory = ""
	elif state == "father5":
		dialogue.text = "Go to Father Jose for further instructions."
		if awaiting_father:
			state = "father6"
	elif state == "father6":
		fr_jose_ico.visible = true
		dialogue.text = "Father Jose: Now, take the altar crucifix and place it on the counter in the sacristy."
		if !awaiting_father:
			state = "crucifix1"
	elif state == "crucifix1":
		fr_jose_ico.visible = false
		chara.inventory = "ac"
		dialogue.text = "Take the altar crucifix and place it on the counter in the sacristy."
		if altar:
			state = "crucifix2"
	elif state == "crucifix2":
		dialogue.text = "Press ENTER to pick up the altar crucifix."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			state = "crucifix3"
			chara.inventory = "altar-crucifix"
			$Sanctuary/Altar/AltarCrucifix.visible = false
			$Control/ColorRect.visible = true
			$Control/ColorRect/Label.text = "Altar Crucifix: A crucifix placed upon the altar to help the celebrant orient himself towards the Lord."
			$Control/ColorRect/TextureRect.texture = load("res://sprites/crucifix.png")
	elif state == "crucifix3":
		dialogue.text = "Place the altar crucifix on the counter in the sacristy."
		if sacristy:
			state = "crucifix4"
	elif state == "crucifix4":
		dialogue.text = "Press ENTER to go into the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "crucifix5"
			$Sanctuary.visible = false 
			$Sanctuary.process_mode = Node.PROCESS_MODE_DISABLED
			$Sacristy.visible = true
			$Sacristy.process_mode = Node.PROCESS_MODE_ALWAYS
			chara.global_position = Vector2(1000, 300)
			sacristy = false
	elif state == "crucifix5":
		dialogue.text = "Place the altar crucifx on the counter."
		if counter:
			state = "crucifix6"
	elif state == "crucifix6":
		dialogue.text = "Press ENTER to place the altar crucifix on the counter."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			state = "father7"
			$Control/ColorRect.visible = false
			$Control/ColorRect/Label.text = ""
			$Sacristy/AltarCrucifix.visible = true
			chara.inventory = ""
			chara.genuflected = false
	elif state == "father7":
		dialogue.text = "Go to Father Jose for further instructions."
		if door:
			state = "father8"
	elif state == "father8":
		dialogue.text = "Press ENTER to exit the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "father9"
			chara.global_position = Vector2(165, 491)
			$Sanctuary.visible = true 
			$Sanctuary.process_mode = Node.PROCESS_MODE_ALWAYS
			$Sacristy.visible = false
			$Sacristy.process_mode = Node.PROCESS_MODE_DISABLED
			door = false
	elif state == "father9":
		dialogue.text = "Go to Father Jose for further instructions."
		if genuflect:
			state = "genuflect4"
	elif state == "genuflect4":
		dialogue.text = "Genuflect in front of the tabernacle."
		if chara.genuflected:
			kneel.play()
			state = "father10"
			genuflect = false
	elif state == "father10":
		dialogue.text = "Go to Father Jose for further instructions."
		if awaiting_father:
			state = "father11"
	elif state == "father11":
		fr_jose_ico.visible = true
		dialogue.text = "Father Jose: Now, take the dressed chalice and put it on the counter in the sacristy."
		if !awaiting_father:
			state = "chalice1"
	elif state == "chalice1":
		fr_jose_ico.visible = false
		dialogue.text = "Take the dressed chalice and put it on the counter in the sacristy."
		chara.inventory = "dc"
		if altar:
			state = "chalice2"
	elif state == "chalice2":
		dialogue.text = "Press ENTER to pick up the dressed chalice."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			state = "chalice3"
			chara.inventory = "dressed-chalice"
			$Sanctuary/Altar/DressedChalice.visible = false
			$Control/ColorRect.visible = true
			$Control/ColorRect/Label.text = "Dressed Chalice: Contains the items necessary for the Liturgy of the Eucharist."
			$Control/ColorRect/TextureRect.texture = load("res://sprites/chalice.png")
	elif state == "chalice3":
		dialogue.text = "Take the dressed chalice and put it on the counter in the sacristy."
		if sacristy:
			state = "chalice4"
	elif state == "chalice4":
		dialogue.text = "Press ENTER to go into the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "chalice5"
			$Sanctuary.visible = false 
			$Sanctuary.process_mode = Node.PROCESS_MODE_DISABLED
			$Sacristy.visible = true
			$Sacristy.process_mode = Node.PROCESS_MODE_ALWAYS
			chara.global_position = Vector2(1000, 300)
			sacristy = false
	elif state == "chalice5":
		dialogue.text = "Place the dressed chalice on the counter."
		if counter:
			state = "chalice6"
	elif state == "chalice6":
		dialogue.text = "Press ENTER to place the chalice on the counter."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			state = "father12"
			$Control/ColorRect.visible = false
			$Control/ColorRect/Label.text = ""
			$Sacristy/DressedChalice.visible = true
			chara.inventory = ""
			chara.genuflected = false
	elif state == "father12":
		dialogue.text = "Go to Father Jose for further instructions."
		if door:
			state = "father13"
	elif state == "father13":
		dialogue.text = "Press ENTER to exit the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "father14"
			chara.global_position = Vector2(165, 491)
			$Sanctuary.visible = true 
			$Sanctuary.process_mode = Node.PROCESS_MODE_ALWAYS
			$Sacristy.visible = false
			$Sacristy.process_mode = Node.PROCESS_MODE_DISABLED
			door = false
	elif state == "father14":
		dialogue.text = "Go to Father Jose for further instructions."
		if genuflect:
			state = "genuflect5"
	elif state == "genuflect5":
		dialogue.text = "Genuflect in front of the tabernacle."
		if chara.genuflected:
			kneel.play()
			state = "father15"
			genuflect = false
	elif state == "father15":
		dialogue.text = "Go to Father Jose for further instructions."
		if awaiting_father:
			state = "father16"
	elif state == "father16":
		fr_jose_ico.visible = true
		dialogue.text = "Father Jose: Now, take the monstrance from the sacristy and place it on the center of the corporal on the altar."
		if !awaiting_father:
			state = "monstrance1"
	elif state == "monstrance1":
		fr_jose_ico.visible = false
		chara.genuflected = false
		dialogue.text = "Get the monstrance from the sacristy and place it on the corporal on the altar."
		if genuflect:
			state = "genuflect6"
	elif state == "genuflect6":
		dialogue.text = "Genuflect in front of the tabernacle."
		if chara.genuflected:
			kneel.play()
			state = "monstrance2"
			genuflect = false
	elif state == "monstrance2":
		dialogue.text = "Get the monstrance from the sacristy and place it on the corporal on the altar."
		if sacristy:
			state = "monstrance3"
	elif state == "monstrance3":
		dialogue.text = "Press ENTER to go into the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "monstrance4"
			$Sanctuary.visible = false 
			$Sanctuary.process_mode = Node.PROCESS_MODE_DISABLED
			$Sacristy.visible = true
			$Sacristy.process_mode = Node.PROCESS_MODE_ALWAYS
			chara.global_position = Vector2(1000, 300)
			sacristy = false
	elif state == "monstrance4":
		dialogue.text = "Get the monstrance and place it on the corporal on the altar."
		if shelf:
			state = "monstrance5"
	elif state == "monstrance5":
		dialogue.text = "Press ENTER to take the monstrance."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			chara.inventory = "monstrance"
			$Sacristy/Monstrance.visible = false
			$Control/ColorRect.visible = true
			$Control/ColorRect/Label.text = "Monstrance: A vessel used to display the Blessed Sacrament during Adoration."
			$Control/ColorRect/TextureRect.texture = load("res://sprites/monstrance-ico.png")
			state = "monstrance6"
	elif state == "monstrance6":
		dialogue.text = "Place the monstrance on the corporal on the altar."
		if door:
			state = "monstrance7"
	elif state == "monstrance7":
		dialogue.text = "Press ENTER to exit the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "monstrance8"
			chara.global_position = Vector2(165, 491)
			$Sanctuary.visible = true 
			$Sanctuary.process_mode = Node.PROCESS_MODE_ALWAYS
			$Sacristy.visible = false
			$Sacristy.process_mode = Node.PROCESS_MODE_DISABLED
			door = false
	elif state == "monstrance8":
		dialogue.text = "Place the monstrance on the corporal on the altar."
		if altar:
			state = "monstrance9"
	elif state == "monstrance9":
		dialogue.text = "Press ENTER to place the monstrance on the corporal."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			state = "father17"
			$Sanctuary/Altar/Monstrance.visible = true
			chara.inventory = "temp"
			$Control/ColorRect.visible = false
			$Control/ColorRect/Label.text = ""
	elif state == "father17":
		dialogue.text = "Go to Father Jose for further instructions."
		if awaiting_father:
			state = "father18"
	elif state == "father18":
		fr_jose_ico.visible = true
		dialogue.text = "Father Jose: Now, take the candles in the sacristy and place them on the altar."
		if !awaiting_father:
			chara.inventory = ""
			state = "candles1"
	elif state == "candles1":
		fr_jose_ico.visible = false
		chara.genuflected = false
		dialogue.text = "Get the candles in the sacristy and place them on the altar."
		if genuflect:
			state = "genuflect7"
	elif state == "genuflect7":
		dialogue.text = "Genuflect in front of the tabernacle."
		if chara.genuflected:
			kneel.play()
			state = "candles2"
			genuflect = false
	elif state == "candles2":
		dialogue.text = "Get the candles in the sacristy and place them on the altar."
		if sacristy:
			state = "candles3"
	elif state == "candles3":
		dialogue.text = "Press ENTER to go into the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "candles4"
			$Sanctuary.visible = false 
			$Sanctuary.process_mode = Node.PROCESS_MODE_DISABLED
			$Sacristy.visible = true
			$Sacristy.process_mode = Node.PROCESS_MODE_ALWAYS
			chara.global_position = Vector2(1000, 300)
			sacristy = false
	elif state == "candles4":
		dialogue.text = "Get the candles and place them on the altar."
		if counter:
			state = "candles5"
	elif state == "candles5":
		dialogue.text = "Press ENTER to pick up the candles."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			state = "candles6"
			chara.inventory = "candles"
			$Sacristy/AltarCandle3.visible = false
			$Sacristy/AltarCandle4.visible = false
			$Control/ColorRect.visible = true
			$Control/ColorRect/Label.text = "Altar Candles: Candles placed upon the altar during adoration to add reverence."
			$Control/ColorRect/TextureRect.texture = load("res://sprites/altar-candles.png")
	elif state == "candles6":
		dialogue.text = "Place the candles on the altar."
		if door:
			state = "candles7"
	elif state == "candles7":
		dialogue.text = "Press ENTER to exit the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "candles8"
			chara.global_position = Vector2(165, 491)
			$Sanctuary.visible = true 
			$Sanctuary.process_mode = Node.PROCESS_MODE_ALWAYS
			$Sacristy.visible = false
			$Sacristy.process_mode = Node.PROCESS_MODE_DISABLED
			door = false
	elif state == "candles8":
		dialogue.text = "Place the candles on the altar."
		if altar:
			state = "candles9"
	elif state == "candles9":
		dialogue.text = "Press ENTER to place the candles on the altar."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			$Sanctuary/Altar/AltarCandle1.visible = true
			$Sanctuary/Altar/AltarCandle2.visible = true
			chara.inventory = "temp"
			$Control/ColorRect.visible = false
			$Control/ColorRect/Label.text = ""
			state = "father19"
	elif state == "father19":
		dialogue.text = "Go to Father Jose for further instructions."
		if awaiting_father:
			state = "father20"
	elif state == "father20":
		fr_jose_ico.visible = true
		dialogue.text = "Father Jose: Now, light the altar candles with the candle lighter in the sacristy."
		if !awaiting_father:
			state = "light1"
	elif state == "light1":
		fr_jose_ico.visible = false
		chara.genuflected = false
		chara.inventory = ""
		dialogue.text = "Light the altar candles with the candle lighter in the sacristy."
		if genuflect:
			state = "genuflect8"
	elif state == "genuflect8":
		dialogue.text = "Genuflect in front of the tabernacle."
		if chara.genuflected:
			kneel.play()
			state = "light2"
			genuflect = false
	elif state == "light2":
		dialogue.text = "Light the altar candles with the candle lighter in the sacristy."
		if sacristy:
			state = "light3"
	elif state == "light3":
		dialogue.text = "Press ENTER to go into the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "light4"
			$Sanctuary.visible = false 
			$Sanctuary.process_mode = Node.PROCESS_MODE_DISABLED
			$Sacristy.visible = true
			$Sacristy.process_mode = Node.PROCESS_MODE_ALWAYS
			chara.global_position = Vector2(1000, 300)
			sacristy = false
	elif state == "light4":
		dialogue.text = "Get the candle lighter."
		if candle_hook:
			state = "light5"
	elif state == "light5":
		dialogue.text = "Press ENTER to get the candle lighter."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			chara.inventory = "candle-lighter"
			$Sacristy/CandleLighter.visible = false
			$Control/ColorRect.visible = true
			$Control/ColorRect/Label.text = "Candle Lighter: Used to light candles with the taper and extinguish the flame with the snuffer."
			$Control/ColorRect/TextureRect.texture = load("res://sprites/lighter.png")
			state = "light6"
	elif state == "light6":
		dialogue.text = "Light the altar candles."
		if door:
			state = "light7"
	elif state == "light7":
		dialogue.text = "Press ENTER to exit the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "light8"
			chara.global_position = Vector2(165, 491)
			$Sanctuary.visible = true 
			$Sanctuary.process_mode = Node.PROCESS_MODE_ALWAYS
			$Sacristy.visible = false
			$Sacristy.process_mode = Node.PROCESS_MODE_DISABLED
			door = false
	elif state == "light8":
		dialogue.text = "Light the altar candles."
		if altar:
			state = "light9"
	elif state == "light9":
		dialogue.text = "Press ENTER to light the altar candles."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			$Sanctuary/Altar/AltarCandle1.play("lit")
			$Sanctuary/Altar/AltarCandle2.play("lit")
			state = "light10"
	elif state == "light10":
		dialogue.text = "Put the candle lighter back in the sacristy."
		if sacristy:
			state = "light11"
	elif state == "light11":
		dialogue.text = "Press ENTER to go into the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "light12"
			$Sanctuary.visible = false 
			$Sanctuary.process_mode = Node.PROCESS_MODE_DISABLED
			$Sacristy.visible = true
			$Sacristy.process_mode = Node.PROCESS_MODE_ALWAYS
			chara.global_position = Vector2(1000, 300)
			sacristy = false
	elif state == "light12":
		dialogue.text = "Put the candle lighter back in the sacristy."
		if candle_hook:
			state = "light13"
	elif state == "light13":
		dialogue.text = "Press ENTER to put the candle lighter back."
		if Input.is_action_just_pressed("ui_accept"):
			pick.play()
			$Sacristy/CandleLighter.visible = true
			chara.inventory = ""
			$Control/ColorRect.visible = false
			$Control/ColorRect/Label.text = ""
			state = "father21"
	elif state == "father21":
		dialogue.text = "Go to Father Jose."
		if door:
			state = "father22"
	elif state == "father22":
		dialogue.text = "Press ENTER to exit the sacristy."
		if Input.is_action_just_pressed("ui_accept"):
			enter.play()
			state = "father23"
			chara.global_position = Vector2(165, 491)
			$Sanctuary.visible = true 
			$Sanctuary.process_mode = Node.PROCESS_MODE_ALWAYS
			$Sacristy.visible = false
			$Sacristy.process_mode = Node.PROCESS_MODE_DISABLED
			door = false
			chara.genuflected = false
	elif state == "father23":
		dialogue.text = "Go to Father Jose."
		if genuflect:
			state = "genuflect9"
	elif state == "genuflect9":
		dialogue.text = "Genuflect in front of the tabernacle."
		if chara.genuflected:
			kneel.play()
			state = "father24"
			genuflect = false
	elif state == "father24":
		dialogue.text = "Go to Father Jose."
		if awaiting_father:
			state = "father25"
	elif state == "father25":
		fr_jose_ico.visible = true
		dialogue.text = "Father Jose: Congratulations! You successfully set up for adoration after Thursday's daily mass. I'm proud of you!"
		$Control/ColorRect.visible = true
		$Control/ColorRect/Label.text = "Success!"
		$Control/ColorRect/TextureRect.texture = load("res://sprites/thumbs_up.png")
	else:
		pass


func _on_genuflect_genuflect() -> void:
	genuflect = true


func _on_jose_zone_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		awaiting_father = true


func _on_jose_zone_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		awaiting_father = false


func _on_credence_table_2_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		credence = true


func _on_credence_table_2_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		credence = false


func _on_sacristy_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		sacristy = true


func _on_sink_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		sink = true


func _on_door_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		door = true


func _on_sink_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		sink = false


func _on_altar_table_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		altar = true


func _on_altar_table_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		altar = false


func _on_chair_2_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		chair = true


func _on_chair_2_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		chair = false


func _on_counter_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		counter = true


func _on_counter_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		counter = false


func _on_shelf_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		shelf = true


func _on_shelf_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		shelf = false


func _on_candle_hook_body_entered(body: Node2D) -> void:
	if body.name == "AltarServer":
		candle_hook = true


func _on_candle_hook_body_exited(body: Node2D) -> void:
	if body.name == "AltarServer":
		candle_hook = false
