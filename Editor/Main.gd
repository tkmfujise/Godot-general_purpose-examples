extends Control

enum FileMenuId { NEW, OPEN, SAVE, SAVE_AS, QUIT }

const NEW_FILE_PLACEHOLDER = "Untitled"
const EXTENSIONS = {
    "Ruby": ["rb", "erb", "ruby"],
    "HTML": ["html", "htm"],
}

var current_file : String
var current_lang : String
var current_syntax : String
var current_theme : String


func _ready() -> void:
    $HBoxContainer/FileMenu.get_popup() \
        .id_pressed.connect(_on_file_menu_selected)
    $CodeArea.grab_focus()
    set_code_theme("Gessetti")
    new_file()


func update_window_title() -> void:
    get_window().title = \
        ProjectSettings.get_setting("application/config/name") \
        + ' - ' + current_file_name()


func new_file():
    current_file   = ''
    $CodeArea.text = ''
    update_window_title()


func current_file_name() -> String:
    if current_file:
        return current_file.get_file()
    else:
        return NEW_FILE_PLACEHOLDER


func save_file():
    if current_file:
        var path = current_file
        var f = FileAccess.open(path, FileAccess.WRITE)
        f.store_string($CodeArea.text)
        f.close()
        current_file = path
        update_window_title()
    else:
        $SaveFileDialog.popup()


func set_code_theme(_theme: String) -> void:
    current_theme = _theme
    var resource  = load("res://code_themes/%s-theme.tres" % _theme)
    $CodeArea.set_code_theme(resource)


func guess_syntax() -> void:
    var ext = current_file.get_extension()
    for key in EXTENSIONS:
        if EXTENSIONS[key].has(ext):
            set_syntax(key)
            return


func set_syntax(lang: String) -> void:
    current_lang = lang
    var resource = load("res://code_syntaxes/%s-syntax.tres" % lang)
    $CodeArea.set_syntax(resource)


func _on_file_menu_selected(id: int) -> void:
    match id:
        FileMenuId.NEW:
            new_file()
        FileMenuId.OPEN:
            $OpenFileDialog.popup()
        FileMenuId.SAVE:
            save_file()
        FileMenuId.SAVE_AS:
            $SaveFileDialog.popup()
        FileMenuId.QUIT:
            get_tree().quit()


func _on_open_file_dialog_file_selected(path: String) -> void:
    var f = FileAccess.open(path, FileAccess.READ)
    $CodeArea.text = f.get_as_text()
    f.close()
    current_file = path
    guess_syntax()
    update_window_title()


func _on_save_file_dialog_file_selected(path: String) -> void:
    var f = FileAccess.open(path, FileAccess.WRITE)
    f.store_string($CodeArea.text)
    f.close()
