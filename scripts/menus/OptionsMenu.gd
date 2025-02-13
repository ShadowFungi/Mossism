extends Control


@export var focused_button : Button
@export_subgroup('Transition Options')
@export var fade_speed : float = 1.0
@export var fade_pattern : String = "fade"
@export var fade_smoothness = 0.1
@export var fade_out_invert : bool = true
@export var fade_in_invert : bool = false
@export var color : Color = Color(0, 0, 0)
@export var timeout : float = 0.0
@export var clickable : bool = false
@export var add_to_back : bool = true


func _ready() -> void:
	js_select_define()


func _on_import_key_map_button_pressed() -> void:
	#print(OS.get_name())
	#print(OS.has_feature('web'))
	if OS.has_feature('web'):
		JavaScriptBridge.eval("upload_map();", true)
		await gui_input
		#print(JavaScriptBridge.eval("fileName;", true))
		#print(JavaScriptBridge.eval("fileData;", true))
#		InputRemapper.import_map_web(JavaScriptBridge.eval("fileData;", true))
	else: $ImportKeyMap.show()


func _on_load_key_map_button_pressed() -> void:
	#InputRemapper.load_map()
	pass


func _on_save_key_map_button_pressed() -> void:
#	InputRemapper.set_default_map()
	$SaveKeyMap.show()


func _on_save_key_map_file_selected(path: String) -> void:
	pass
#	InputRemapper.save_map(path)


func _on_import_key_map_file_selected(path: String) -> void:
	pass
#	InputRemapper.import_map(path)


func _on_back_button_pressed() -> void:
	get_parent().get_child(1).show()
	self.hide()


func js_select_define():
	JavaScriptBridge.eval(
		"""
	var fileData;
	var fileType;
	var fileName;
	var canceled;
	function upload_map() {
		canceled = true;
		var input = document.createElement('INPUT');
		input.setAttribute("type", "file");
		input.setAttribute("accept", ".cfg");
		input.click();
		input.addEventListener('change', event => {
			if (event.target.files.length > 0){
				canceled = false;}
			var file = event.target.files[0];
			var reader = new FileReader();
			fileType = file.type;
			fileName = file.name;
			reader.readAsText(file);
			reader.onloadend = function (evt) {
				if (evt.target.readyState == FileReader.DONE) {
					fileData = evt.target.result;
				}
			}
			fileData = file.text
		});
	}
	""",
		true
	)


func _on_remap_keys_toggled(button_pressed: bool) -> void:
	if button_pressed == true:
		get_node('MarginContainer/TabContainer/KEYMAPS/ScrollContainer').show()
		get_node('MarginContainer/TabContainer/KEYMAPS/ScrollContainer').set_process_unhandled_key_input(true)
	else:
		get_node('MarginContainer/TabContainer/KEYMAPS/ScrollContainer').hide()
		get_node('MarginContainer/TabContainer/KEYMAPS/ScrollContainer').set_process_unhandled_key_input(false)


func _on_visibility_changed() -> void:
	if visible == true:
		focused_button.grab_focus()
