extends Control

var mouse_focus = false
signal button_pressed
signal button_mouse_exit
var item_index
var item_stats : Array
var item_url = "res://Assets/Img/Item Icons/"
var item_name
var dot_png = ".png"


func _on_button_focus_entered():
	mouse_focus = true
	button_pressed.emit()

func _on_button_focus_exited():
	mouse_focus = false

func set_item_index(number):
	item_index = number

func set_item_stats(item):
	item_name = item[0]
	$Button/TextureRect.texture = load(item_url + item_name + dot_png)
	item_stats.append_array(item)

func _on_button_mouse_entered():
	button_pressed.emit()

func _on_button_mouse_exited():
	button_mouse_exit.emit()
