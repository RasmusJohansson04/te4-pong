extends CharacterBody2D

var floating_text = preload("res://Scenes/Enemeys/floating_text.tscn")

var paused = True.True
@export var enemy_name = "alexandro"
@export var speed : float = 300.0
@export var can_be_stund = true
var fire_damage = 10
var darkness_stack = 0
var weakness = "ljus"
var resistance : float = 10
var enemy_element
var max_hp = 100 * global.diff_scale
var hp = max_hp
var damage = 25
var fire_rate = [0.5,1,2]
var BULLET = preload("res://Scenes/Ball/Ball.tscn")
var can_shoot = true
var slow_speed : float = 0
var direction = 1
var min_degrees = -1
var max_degrees = 1
var size = Vector2(0,0)

func item_stacking():
	for n in range(global.player_items_index.size()):
		if(global.player_items_index[n] == 1):
			fire_damage *= 2

func _physics_process(delta):
	if !paused:
		if position.y < 2 + $Area2D/CollisionShape2D.shape.size.y/2 or position.y > get_viewport_rect().size.y - $Area2D/CollisionShape2D.shape.size.y/2-2:
			direction *= -1
		if direction:
			velocity.y = direction * (speed * (1-slow_speed/100))
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
		
		move_and_slide()

func shoot():
	if(can_shoot): 
		get_tree().get_first_node_in_group("world").spawn_ball(position.x - $Area2D/CollisionShape2D.shape.size.x/2 - global.ball_size.x, position.y, -1 , randf_range(min_degrees, max_degrees),damage)
		$Timer.wait_time = fire_rate.pick_random()
		$Timer.start()

func take_damage(dmg):
	var new_resistance : float = round(resistance * pow(0.99, darkness_stack))
	if dmg*(1-new_resistance/100)<hp:
		hp-=dmg*(1-new_resistance/100)
		get_tree().get_first_node_in_group("enemy_health").clear()
		get_tree().get_first_node_in_group("enemy_health").append_text("[center]" + str(ceil(hp)) + " HP[/center]")
		get_tree().get_first_node_in_group("enemy_health_bar").value = hp/max_hp*100
		var text = floating_text.instantiate()
		text.amount = dmg*(1-new_resistance/100)
		add_child(text)
	else:
		die()

func die():
	if(global.player_hp<100):
		global.player_hp += 25
	global.diff_scale *= 1.5
	queue_free()
	get_tree().paused = true
	get_tree().get_first_node_in_group("item_selection").show()
	#get_tree().change_scene_to_file("res://Scenes/Map/World/WorldMap.tscn")

func element_effect(element):
	match element:
		"fire":
			element_fire()
		"ice":
			element_ice()
		"lightning":
			element_lightning()
		"light":
			element_light()
		"air":
			element_air()
		"water":
			element_water()
		"darkness":
			element_darkness()
		"spirit":
			pass
		_:
			print("no elemento")

func element_fire():
	if($FireBrunTimer.is_stopped()):
		$FireBrunTimer.start()
		$FireTickTimer.start()
	else:
		$FireBrunTimer.start()

func element_ice():
	$IceSlowTimer.start()
	slow_speed = 30
 

func element_lightning():
	pass
	# chanse for lightning bolt (kanske ska vara i player)

 
func element_earth():
	print("earh")
	# big rock (kanske ska vara i ball)


func element_air():
	print("air")
	# buff? (kanske ska vara i player)


func element_water():
	print("water")
	# shotgun? (kanske ska vara i player)


func element_light():
	if(can_be_stund):
		$LightStunTimer.start()
		can_shoot = false
		slow_speed = 100

func element_darkness():
	for n in range(global.player_items_index.size()):
		if(global.player_items_index[n] == 4):
			darkness_stack += 5

func element_spirit():
	print("spirti")
	# makes to balls (kanske ska vara i player)


func _on_area_2d_body_entered(body):
	body.queue_free()
	take_damage(body.damage)
	for n in range(body.element.size()):
		element_effect(body.element[n])


func _on_timer_timeout():
	shoot()


func _on_movement_timer_timeout():
	direction *= -1
	$MovementTimer.wait_time = RandomNumberGenerator.new().randf_range(1, 5)
  
  
func _on_fire_brun_timer_timeout():
	$FireTickTimer.stop()
	$FireBrunTimer.stop()


func _on_fire_tick_timer_timeout():
	take_damage(fire_damage)


func _on_ice_slow_timer_timeout():
	slow_speed = 0


func _on_light_stun_timer_timeout():
	can_shoot = true
	slow_speed = 0
