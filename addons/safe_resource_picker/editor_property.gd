class_name SafeResourcePickerEditorProperty extends EditorProperty

var _picker: EditorResourcePicker
var _open_button: Button

func _init(type: String) -> void:
	_picker = EditorResourcePicker.new()
	_picker.base_type = type
	_picker.resource_changed.connect(_on_resource_changed)
	_picker.resource_selected.connect(_on_resource_selected)
	_open_button = Button.new()
	_open_button.pressed.connect(_on_open_button_pressed)
	_open_button.visible = false
	_open_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_open_button.custom_minimum_size = Vector2(165.0, 1.0)
	add_child(_picker)
	add_child(_open_button)
	set_bottom_editor(_open_button)

func _on_open_button_pressed() -> void:
	var r: Resource = _picker.edited_resource
	if r == null || r.resource_path == "":
		return
	if r is PackedScene:
		EditorInterface.open_scene_from_path(r.resource_path)
	else:
		EditorInterface.edit_resource(r)

func _on_resource_selected(r: Resource, inspect: bool) -> void:
	_open_button.visible = !_open_button.visible

func _on_resource_changed(r: Resource) -> void:
	_open_button.visible = false
	if r == null:
		emit_changed(get_edited_property(), null)
	elif r.resource_path == "":
		printerr(SRP_HINT.LOCAL_RESOURCE_ERROR_STRING)
		return
	else:
		_set_button(r)
		emit_changed(
			get_edited_property(),
			ResourceUID.id_to_text(
				ResourceLoader.get_resource_uid(r.resource_path)
			)
		)

func _update_property() -> void:
	var current_path: String = get_edited_object()[get_edited_property()]
	if current_path:
		_picker.edited_resource = load(current_path)
		_set_button(_picker.edited_resource)
	else:
		_picker.edited_resource = null

func _set_button(r: Resource) -> void:
	if r is PackedScene:
		_open_button.icon = get_theme_icon("PackedScene", &"EditorIcons")
		_open_button.text = "Open Scene"
	else:
		_open_button.icon = get_theme_icon("ResourcePreloader", &"EditorIcons")
		_open_button.text = "Open Resource"
