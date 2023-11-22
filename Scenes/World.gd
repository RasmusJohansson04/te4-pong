extends Node
var screensize
@export var maxScore = 11
signal pauseSignal
var BALL = preload("res://Scenes/Ball.tscn")

func spawn_ball(x,y):
	print("spawning ball")
	var ball =  BALL.instantiate()
	ball.global_position = Vector2(x,y)
	ball.direction.x = -1
	add_child(ball)

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport().get_visible_rect().size
	$enemy.shoot()

func _on_norr_body_entered(body):
	if !body.is_in_group('paddles'):
		body.direction.y *= -1


func _on_bottom_body_entered(body):
	if !body.is_in_group('paddles'):
		body.direction.y *= -1



func _on_kanye_body_entered(body):
	Main.p2_score += 1
	$Control/Label2.text = str("x" + str(Main.p2_score))
	
	await get_tree().create_timer(1).timeout
	
	body.queue_free()
	if Main.p2_score >= maxScore:
		$Control/Label3.text = ("Player 2 won")
		pauseGame()

func _on_left_body_entered(body):#!left
	Main.p1_score += 1
	$Control/Label.text = str("x" + str(Main.p1_score))
	
	await get_tree().create_timer(1).timeout
	
	body.queue_free()
	if Main.p1_score >= maxScore:
		$Control/Label3.text = ("Player 1 won")
		pauseGame()
	

func pauseGame():
	$Control/Label3.visible = true
	$Control/PlayAgain.visible = true
	$Control/MainMenu.visible = true
	pauseSignal.emit()

func _on_play_again_pressed():
	Main.p1_score = 0
	Main.p2_score = 0
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_main_menu_pressed():
	Main.p1_score = 0
	Main.p2_score = 0
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
