extends CodeEdit

var current_syntax : SyntaxResource
var current_theme : ThemeResource


func _ready() -> void:
    syntax_highlighter = CodeHighlighter.new()


func set_code_theme(theme: ThemeResource) -> void:
    current_theme = theme
    add_theme_color_override("background_color", theme.background_color)
    add_theme_color_override("font_color", theme.foreground_color)
    syntax_highlighter.set_symbol_color(theme.symbol_color)
    syntax_highlighter.set_number_color(theme.number_color)
    syntax_highlighter.set_function_color(theme.function_color)


func set_syntax(syntax: SyntaxResource) -> void:
    clear_syntax_highlighter()
    current_syntax = syntax
    indent_size = syntax.indent_size
    for key in syntax.regions:
        for arr in syntax.regions[key]:
            if current_theme.syntax_colors.has(key):
                syntax_highlighter.add_color_region(
                    arr[0], arr[1], current_theme.syntax_colors[key]
                )

    for key in syntax.keywords:
        for value in syntax.keywords[key]:
            if current_theme.syntax_colors.has(key):
                syntax_highlighter.add_keyword_color(value, current_theme.syntax_colors[key])


func clear_syntax_highlighter():
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
