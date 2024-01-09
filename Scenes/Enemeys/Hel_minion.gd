extends CharacterBody2D

var floating_text = preload("res://Scenes/Enemeys/floating_text.tscn")

@export var speed : float = 300.0
@export var enemy_name = "alexandro"
var weakness = "ljus"
var resistance : float = 10
var hp = 100
var damage = 10
var fire_rate = 5
var paused = false
var BULLET = preload("res://Scenes/Ball/Ball.tscn")
var direction = 1

func _ready():
	speed = 0
	resistance = 0

func shoot():
	owner.spawn_ball(position.x - $Area2D/CollisionShape2D.shape.size.x/2 - global.ball_size.x, position.y)
	$Timer.wait_time = [0.5,1,2].pick_random()
	$Timer.start()

func _physics_process(delta):
	if !paused:
		if position.y < 2 + $Area2D/CollisionShape2D.shape.size.y/2 or position.y > get_viewport_rect().size.y - $Area2D/CollisionShape2D.shape.size.y/2-2:
			direction *= -1
		if direction:
			velocity.y = direction * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
		
		move_and_slide()
		
func take_damage(dmg):
	if dmg*(1-resistance/100)<hp:
		hp-=dmg*(1-resistance/100)
		$TextureProgressBar.value = hp
		var text = floating_text.instantiate()
		text.amount = dmg*(1-resistance/100)
		add_child(text)
	else:
		die()

func die():
	queue_free()


func _on_area_2d_body_entered(body):
	body.queue_free()
	take_damage(25)


func _on_movement_timer_timeout():
	direction *= -1
	$MovementTimer.wait_time = RandomNumberGenerator.new().randf_range(1, fire_rate)
