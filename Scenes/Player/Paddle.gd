extends CharacterBody2D

@export var speed : float = 300.0
@export var side = 'p1'

var max_bounce_angle = 0.5235987756 		#30
var paused = false
var recently_hit = false

func _physics_process(delta):
	var direction
	if !paused:
		if side == 'p1':
			direction = get_axis('P1_UP', 'P1_DOWN')
		else:
			direction = get_axis('P2_UP', 'P2_DOWN')
		if direction:
			velocity.y = direction * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
		
		move_and_slide()

func get_axis(up, down):
	if Input.is_action_pressed(up): return -1
	elif Input.is_action_pressed(down): return 1


func _on_area_2d_body_entered(body):
	
	var body_x_direction = body.direction.x
	var body_collision : CollisionShape2D = body.get_node("CollisionShape2D")
	var body_height = body_collision.shape.get_rect().size.y
	var collision : CollisionShape2D = $Area2D/CollisionShape2D
	var collision_height = collision.shape.get_rect().size.y
	
	var dist = (position.y+(collision_height/2)) - (body.position.y)
	var normalizedDist = dist/(collision_height/2)
	
	var bounceAngle = -1 * normalizedDist * max_bounce_angle
	
	var dir
	if body_x_direction < 0:
		dir = 1
	else:
		dir = -1
	
	if not recently_hit:
		body.direction = Vector2(cos(bounceAngle) * dir, sin(bounceAngle))
		global.side = side 
		recently_hit = true
		$RecentHitTimer.start()


func _on_world_pause_signal():
	paused = true


func _on_recent_hit_timer_timeout():
	recently_hit = false
