extends Node2D
var lokacja
var papa = 0
var aktualny_slime = null
@export var sila_odbicia: float = 5000.0
@export var strata_sil_Kamila: float = 0.75 
var aktualna_sila: float = 0.0
var Kamil_pozwala_odbic: bool = true
@export var sila_w_lewo: float = 1500.0

signal papamobil
signal papamobil2
signal papamobil3

var mapa_y = -8647
var mapa_x = 34
var pick1 = 1
var pick2 = 1
var pick3 = 1
var slime1
var slime2
var slime3






func _ready():
	papamobil.connect(on_papa)
	papamobil2.connect(on_papa2)
	papamobil3.connect(on_papa3)
	#$Slime.position.x = 300 + mapa_x
	#$Slime.position.y = 2700 + mapa_y
	#$Slime2.position.x = 340 + mapa_x
	#$Slime2.position.y = 2700 + mapa_y
	#$Slime3.position.x = 380 + mapa_x
	#$Slime3.position.y = 2700 + mapa_y
	#$Ksztalty.position.x = 300 + mapa_x
	#$Ksztalty.position.y = 2880 + mapa_y
	$Slime.position.x = 334
	$Slime.position.y = -5947
	$Slime2.position.x = 374
	$Slime2.position.y = -5947
	$Slime3.position.x = 414
	$Slime3.position.y = -5947
	$Ksztalty.position.x = 334
	$Ksztalty.position.y = -5767
	slime1 = $Slime
	slime2 = $Slime2
	slime3 = $Slime3




func _process(delta: float): 
	lokacja = get_global_mouse_position()
	if Input.is_action_just_pressed("koniec"):
		get_tree().quit()
	if Input.is_action_just_pressed("Lecimy"):
		$"Ksztalty".freeze = false
		$Timer.start()
	$CanvasLayer/Ilosc_slimow.text = str(120 - $Timer.time_left)
	
	

	
	




func _on_slime_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and pick1 == 1:
		$Slime.position = lokacja
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				slime1.rotate(-0.1)
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				slime1.rotate(0.1)
	else:
		papamobil.emit()
	
		
		
	
func on_papa():
	var slime = slime1
	if slime == null:
		return
	if $Ksztalty/Area2D in slime.get_overlapping_areas():
		var pos = slime.global_position
		var slimek = slime.get_node("Sprite2D").duplicate()
		var hit = slime.get_node("CollisionShape2D").duplicate()
		$Ksztalty.add_child(slimek)
		slimek.visible = false
		$Ksztalty.add_child(hit)
		slimek.global_position = pos
		hit.global_position = pos
		slime.reparent($Ksztalty)
		pick1 = 0
		

	else:
		slime.position = Vector2(300 + mapa_x, 2700 + mapa_y)
	
	
		
		
		
func on_papa2():
	var slime = slime2
	if slime == null:
		return
	if $Ksztalty/Area2D in slime.get_overlapping_areas():
		var pos = slime.global_position
		var slimek = slime.get_node("Sprite2D").duplicate()
		var hit = slime.get_node("CollisionShape2D").duplicate()
		$Ksztalty.add_child(slimek)
		slimek.visible = false
		$Ksztalty.add_child(hit)
		slimek.global_position = pos
		hit.global_position = pos
		slime.reparent($Ksztalty)
		pick2 = 0

	else:
		slime.position = Vector2(340 + mapa_x, 2700 + mapa_y)
		
		
		
		
		
func on_papa3():
	var slime = slime3
	if slime == null:
		return
	if $Ksztalty/Area2D in slime.get_overlapping_areas():
		var pos = slime.global_position
		var slimek = slime.get_node("Sprite2D").duplicate()
		var hit = slime.get_node("CollisionShape2D").duplicate()
		$Ksztalty.add_child(slimek)
		slimek.visible = false
		$Ksztalty.add_child(hit)
		slimek.global_position = pos
		hit.global_position = pos
		slime.reparent($Ksztalty)
		pick3 = 0

	else:
		slime.position = Vector2(380 + mapa_x, 2700 + mapa_y)



func _on_slime_3_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and pick3 == 1:
		$Slime3.position = lokacja
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				slime3.rotate(-0.1)
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				slime3.rotate(0.1)
	else:
		papamobil3.emit()


func _on_slime_2_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and pick2 == 1:
		$Slime2.position = lokacja
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				slime2.rotate(-0.1)
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				slime2.rotate(0.1)
	else:
		papamobil2.emit()



func _on_slime_body_entered(body):
		if body.is_in_group("Podloga") and Kamil_pozwala_odbic == true:
			Kamil_pozwala_odbic = false
			var kierunek = Vector2.UP.rotated($Ksztalty/Slime.global_rotation)  
			var przesuniecie = $Ksztalty/Slime.global_position - $Ksztalty.global_position
			$Ksztalty.linear_velocity = Vector2.ZERO
			$Ksztalty.apply_impulse(kierunek * sila_odbicia, przesuniecie)
			await get_tree().create_timer(0.01).timeout
			Kamil_pozwala_odbic = true
			
			




func _on_button_pressed():
	#$Slime.position.x += 6424
	#$Slime.position.y += 8018
	#$Slime2.position.x += 6464
	#$Slime2.position.y += 8018
	#$Slime3.position.x += 6504
	#$Slime3.position.y += 8018
	$Ksztalty.position.x += 6700
	$Ksztalty.position.y += 8600

func _on_powrót_pressed():
	$Ksztalty.position.x -= 6700
	$Ksztalty.position.y -= 8600



func _on_button_2_pressed():
	pass # Replace with function body.


func _on_button_3_pressed():
	pass # Replace with function body.


func _on_button_4_pressed():
	pass # Replace with function body.



func _on_slime_3_body_entered(body):
		if body.is_in_group("Podloga") and Kamil_pozwala_odbic == true:
			Kamil_pozwala_odbic = false
			var kierunek = Vector2.UP.rotated($Ksztalty/Slime3.global_rotation)  
			var przesuniecie = $Ksztalty/Slime3.global_position - $Ksztalty.global_position
			$Ksztalty.linear_velocity = Vector2.ZERO
			$Ksztalty.apply_impulse(kierunek * sila_odbicia, przesuniecie)
			await get_tree().create_timer(0.01).timeout
			Kamil_pozwala_odbic = true


func _on_slime_2_body_entered(body):
		if body.is_in_group("Podloga") and Kamil_pozwala_odbic == true:
			Kamil_pozwala_odbic = false
			var kierunek = Vector2.UP.rotated($Ksztalty/Slime2.global_rotation)  
			var przesuniecie = $Ksztalty/Slime2.global_position - $Ksztalty.global_position
			$Ksztalty.linear_velocity = Vector2.ZERO
			$Ksztalty.apply_impulse(kierunek * sila_odbicia, przesuniecie)
			await get_tree().create_timer(0.01).timeout
			Kamil_pozwala_odbic = true


func _on_ksztalty_body_entered(body):
	$Timer.stop()
	if body.is_in_group("WIN"):
		$CanvasLayer/Ilosc_slimow.text = "MEGA BIG WIN"
	
