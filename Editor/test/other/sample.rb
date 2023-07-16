#
# 
#
#
#
#
# Sample Editor with Godot Game Engine. 2023 tkmfujise
#
class Editor < GodotGeneranlPurposeExamples
  attr_accessor :themes, :syntaxes
  
  def features
    [
      "Syntax Highlight",
      "Indentation",
      "File I/O",
      "Auto Completion",
      "Editor Theme",
      "Keyboard Shortcut",
    ]
  end

  def cloneable?
    true # Go ahead
  end
end