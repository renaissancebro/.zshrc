; extends

; VS Code-style template literal highlighting - enhanced
; Template substitution braces with high priority
(template_substitution
  "${" @punctuation.special.template
  "}" @punctuation.special.template
  (#set! "priority" 135))

; Template literal expressions
(template_substitution
  (identifier) @variable
  (#set! "priority" 125))

(template_substitution
  (call_expression
    function: (identifier) @function.call)
  (#set! "priority" 125))

(template_substitution
  (member_expression
    object: (identifier) @variable
    property: (property_identifier) @variable.member)
  (#set! "priority" 125))

; Enhanced bracket highlighting with different colors
; Function call parentheses
(call_expression
  "(" @punctuation.bracket
  ")" @punctuation.bracket
  (#set! "priority" 110))

; Array brackets
(array
  "[" @punctuation.bracket
  "]" @punctuation.bracket
  (#set! "priority" 110))

; Object braces (but not template literal braces)
(object
  "{" @punctuation.bracket
  "}" @punctuation.bracket
  (#set! "priority" 110))

; Member access brackets
(member_expression
  "[" @punctuation.bracket
  "]" @punctuation.bracket
  (#set! "priority" 110))

; Parameter lists
(formal_parameters
  "(" @punctuation.bracket
  ")" @punctuation.bracket
  (#set! "priority" 110))

; Arrow function parameters
(arrow_function
  parameters: (formal_parameters
    "(" @punctuation.bracket
    ")" @punctuation.bracket)
  (#set! "priority" 110))

; Function expressions and declarations
(function_declaration
  name: (identifier) @function
  (#set! "priority" 115))

(function_expression  
  name: (identifier) @function
  (#set! "priority" 115))

; Method definitions
(method_definition
  name: (property_identifier) @function.method
  (#set! "priority" 115))

; Enhanced function calls
(call_expression
  function: (identifier) @function.call
  (#set! "priority" 115))

(call_expression
  function: (member_expression
    property: (property_identifier) @function.method)
  (#set! "priority" 115))

; Built-in objects and functions
((identifier) @function.builtin
 (#any-of? @function.builtin
   "console" "Math" "Date" "Array" "Object" "String" "Number" 
   "Boolean" "RegExp" "Error" "JSON" "Promise" "Set" "Map"))

; Constants
((identifier) @constant
 (#any-of? @constant "undefined" "null" "true" "false" "Infinity" "NaN"))

; This keyword
((this) @keyword.this (#set! "priority" 115))