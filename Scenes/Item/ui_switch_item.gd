extends Control

signal yes_button
signal button1
signal button2
signal button3
var give_buttons_item : Array
var give_buttons_item_index : Array
var button_true
var send_index
var send_name
var send_desc
var boss = false

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func on_item_start(item, item_index):
	give_buttons_item = item
	give_buttons_item_index = item_index
	
	$button1.set_item_index(give_buttons_item_index[0])
	$button1.set_item_stats(give_buttons_item[0])
	
	$button2.set_item_index( give_buttons_item_index[1])
	$button2.set_item_stats(give_buttons_item[1])
	
	$button3.set_item_index( give_buttons_item_index[2])
	$button3.set_item_stats(give_buttons_item[2])

func _on_yes_button_pressed():
	if(button_true[0]):
		global.update_player_items_index($button1.item_index)
		player_item.set_player_item($button1.item_stats)
	elif (button_true[1]):
		global.update_player_items_index($button2.item_index)
		player_item.set_player_item($button2.item_stats)
	else:
		global.update_player_items_index($button3.item_index)
		player_item.set_player_item($button3.item_stats)
	
	if(boss):
		boss = !boss
		get_tree().change_scene_to_file("res://Scenes/Map/Overworld/Overworld.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Map/World/WorldMap.tscn")
	get_tree().paused = false
	yes_button.emit()

func _on_button_1_button_pressed():
	button_true = get_button_mouse_focus()
	send_index = $button1.item_index
	send_name = $button1.item_stats[0]
	send_desc = $button1.item_stats[1]
	button1.emit()

func _on_button_2_button_pressed():
	button_true = get_button_mouse_focus()
	send_index = $button2.item_index
	send_name = $button2.item_stats[0]
	send_desc = $button2.item_stats[1]
	button2.emit()

func _on_button_3_button_pressed():
	button_true = get_button_mouse_focus()
	send_index = $button3.item_index
	send_name = $button3.item_stats[0]
	send_desc = $button3.item_stats[1]
	button3.emit()

func get_button_mouse_focus():
	var button1 = get_node("button1").mouse_focus
	var button2 = get_node("button2").mouse_focus
	var button3 = get_node("button3").mouse_focus
	$YesButton.disabled = false
	return [button1, button2, button3]


func _on_button_1_button_mouse_exit():
	update_text_when_mouse_exit()

func _on_button_2_button_mouse_exit():
	update_text_when_mouse_exit()


func _on_button_3_button_mouse_exit():
	update_text_when_mouse_exit()


func update_text_when_mouse_exit():
	var button1_focus = get_node("button1").mouse_focus
	var button2_focus = get_node("button2").mouse_focus
	var button3_focus = get_node("button3").mouse_focus
	match true:
		button1_focus:
			send_name = $button1.item_stats[0]
			send_desc = $button1.item_stats[1]
			button1.emit()
		button2_focus:
			send_name = $button2.item_stats[0]
			send_desc = $button2.item_stats[1]
			button2.emit()
		button3_focus:
			send_name = $button3.item_stats[0]
			send_desc = $button3.item_stats[1]
			button3.emit()
		_:
			return
