extends CodeEdit

const COLORS = {
    "background": "#062037",
    "foreground": "#FFFFFF",
    "punctuation": "#FFFFFF",
    "symbol": "#FBFBD3",
    "constant": "#DCF710",
    "boolean": "#98E1FF",
    "entity": "#FDFF9A",
    "type_name": "#FFB3E9",
    "function_color": "#F9B7DC",
    "keyword": "#F4B043",
    "number": "#FFFFFF",
    "string": "#46F009",
    "comment": "#5DA9EC",
}


var current_lang : String
var current_syntax : SyntaxResource


func _ready() -> void:
    syntax_highlighter = CodeHighlighter.new()
    set_code_theme("Gessetti")
    set_code_language("ruby")


func set_code_theme(theme: String) -> void:
    add_theme_color_override("background_color", COLORS["background"])
    add_theme_color_override("font_color", COLORS["foreground"])
    syntax_highlighter.set_symbol_color(COLORS["symbol"])
    syntax_highlighter.set_number_color(COLORS["number"])
    syntax_highlighter.set_function_color(COLORS["function_color"])


func set_code_language(lang: String) -> void:
    current_lang = lang
    var resource = load("res://syntax/%s-syntax.tres" % lang)
    clear_syntax()
    set_syntax(resource)


func set_syntax(resource: SyntaxResource) -> void:
    current_syntax = resource
    indent_size    = resource.indent_size
    for key in resource.regions:
        for arr in resource.regions[key]:
            if COLORS.has(key):
                syntax_highlighter.add_color_region(
                    arr[0], arr[1], COLORS[key]
                )

    for key in resource.keywords:
        for value in resource.keywords[key]:
            if COLORS.has(key):
                syntax_highlighter.add_keyword_color(value, COLORS[key])


func clear_syntax():
    syntax_highlighter.clear_highlighting_cache()
    syntax_highlighter.clear_color_regions()
    syntax_highlighter.clear_keyword_colors()
    syntax_highlighter.clear_member_keyword_colors()


func _on_code_completion_requested() -> void:
    for arr in current_syntax.completions:
        add_code_completion_option(CodeEdit.KIND_PLAIN_TEXT, arr[0], arr[1])

    update_code_completion_options(true)


func _on_text_changed() -> void:
    if get_word_at_pos(get_caret_draw_pos()).length() > 0:
        request_code_completion(true)
