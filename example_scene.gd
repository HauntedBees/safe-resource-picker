extends Node3D

var _state := 0
var _regular_resource_load_time := 0.0
var _regular_resource_node_time := 0.0
var _safe_resource_load_time := 0.0
var _safe_resource_node_time := 0.0
var _current_resource: Resource
var _current_node: Node

@onready var _label: Label = %Label
@onready var _button: Button = %Button

func _init() -> void:
	var r := load("res://res_a.tres")
	print(r.resource_path)
	print(load(r.b).resource_path)
	print(load(load(r.b).a).resource_path)

func _on_button_pressed() -> void:
	match _state:
		0:
			var timer := Time.get_ticks_msec()
			_current_resource = load("res://res_norm.tres")
			_regular_resource_load_time = Time.get_ticks_msec() - timer
			_label.text = "A Resource containing PackedScene references to 19 different 19MB glb model has just been loaded. It took %d milliseconds. Notice the changes in the Monitors in the Debugger tab, despite nothing being added to the scene yet. Click the button below to add one of the loaded GLBs to the scene." % _regular_resource_load_time
			_button.text = "Add Node"
		1:
			var timer := Time.get_ticks_msec()
			_current_node = (_current_resource as NormalResource).scene.instantiate()
			add_child(_current_node)
			_regular_resource_node_time = Time.get_ticks_msec() - timer
			_label.text = "It took %d milliseconds to instantiate that PackedScene and add it to the scene. It was pretty fast since the PackedScene had already been loaded in the previous step. Now click the button to clear everything and watch the Monitors values drop back down." % _regular_resource_node_time
			_button.text = "Remove Node and Unload Resource"
		2:
			_current_node.queue_free()
			_current_node = null
			_current_resource = null
			_label.text = "All gone. Now try loading the Safe Resource, which contains just the UIDs of those same 19MB glb files."
			_button.text = "Load Safe Resource into Memory"
		3:
			var timer := Time.get_ticks_msec()
			_current_resource = load("res://res_safe.tres")
			_safe_resource_load_time = Time.get_ticks_msec() - timer
			_label.text = "That only took %d milliseconds. Notice the changes in the Monitors in the Debugger tab compared to the previous resource. Click the button below to add one of the loaded GLBs to the scene." % _safe_resource_load_time
			_button.text = "Add Node"
		4:
			var timer := Time.get_ticks_msec()
			_current_node = (load((_current_resource as SafeResource).scene_path) as PackedScene).instantiate()
			add_child(_current_node)
			_safe_resource_node_time = Time.get_ticks_msec() - timer
			_label.text = "It took %d milliseconds to instantiate that PackedScene and add it to the scene. It took a bit longer since the 19MB model itself wasn't actually loaded until it was needed. Now click the button to clear everything one more time." % _safe_resource_node_time
			_button.text = "Remove Node and Unload Resource"
		5:
			_current_node.queue_free()
			_current_node = null
			_current_resource = null
			_label.text = "It took %dms to load the normal resource, and %dms to load the safe one. If you want to see the changes in the Monitors again, click the button to restart the example." % [_regular_resource_load_time, _safe_resource_load_time]
			_button.text = "Restart"
		6:
			_label.text = "Run this scene in the Godot Editor, then while it's running, switch to the Debugger and check the \"Memory - Static Max\", \"Object - Resources\", and all 3 options in the \"Video\" section. Observe their values, then click the button below."
			_button.text = "Load Standard Resource into Memory"
			_state = 0
			return
	_state += 1
