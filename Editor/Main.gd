extends Control

var current_lang : String
var current_syntax : String
var current_theme : String

func _ready() -> void:
    $CodeEdit.grab_focus()
    set_code_theme("Gessetti")
    set_syntax("Ruby")


func set_code_theme(theme: String) -> void:
    current_theme = theme
    var resource  = load("res://themes/%s-theme.tres" % theme)
    $CodeEdit.set_code_theme(resource)


func set_syntax(lang: String) -> void:
    current_lang = lang
    var resource = load("res://syntaxes/%s-syntax.tres" % lang)
    $CodeEdit.set_syntax(resource)
