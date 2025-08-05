; extends

; VS Code-style f-string highlighting - enhanced
; F-string prefix (the 'f' before quotes)
(string
  (string_start) @string.special
  (#lua-match? @string.special "^f")
  (#set! "priority" 130))

; F-string interpolation braces with enhanced priority
(interpolation
  "{" @punctuation.special
  "}" @punctuation.special
  (#set! "priority" 135))

; F-string content expressions
(interpolation
  (identifier) @variable
  (#set! "priority" 125))

(interpolation
  (call
    function: (identifier) @function.call)
  (#set! "priority" 125))

(interpolation
  (attribute
    object: (identifier) @variable
    attribute: (identifier) @variable.member)
  (#set! "priority" 125))

; Format specifiers in f-strings
(format_specifier) @string.escape

; Enhanced bracket highlighting with different colors
; Function call parentheses
(call
  "(" @punctuation.bracket.call
  ")" @punctuation.bracket.call
  (#set! "priority" 110))

; List brackets
(list
  "[" @punctuation.bracket.list
  "]" @punctuation.bracket.list  
  (#set! "priority" 110))

; Dictionary/set braces (but not f-string braces)
(dictionary
  "{" @punctuation.bracket.dict
  "}" @punctuation.bracket.dict
  (#set! "priority" 110))

(set
  "{" @punctuation.bracket.set
  "}" @punctuation.bracket.set
  (#set! "priority" 110))

; Tuple parentheses
(tuple
  "(" @punctuation.bracket.tuple
  ")" @punctuation.bracket.tuple
  (#set! "priority" 110))

; Subscript brackets
(subscript
  "[" @punctuation.bracket.subscript
  "]" @punctuation.bracket.subscript
  (#set! "priority" 110))

; Parameter lists
(parameters
  "(" @punctuation.bracket.params
  ")" @punctuation.bracket.params
  (#set! "priority" 110))

; Function definitions
(function_definition
  name: (identifier) @function
  (#set! "priority" 115))

; Enhanced function calls
(call
  function: (identifier) @function.call
  (#set! "priority" 115))

(call  
  function: (attribute
    attribute: (identifier) @function.method)
  (#set! "priority" 115))

; Built-in functions
((identifier) @function.builtin
 (#any-of? @function.builtin
   "print" "len" "range" "enumerate" "zip" "map" "filter" 
   "sorted" "sum" "max" "min" "abs" "round" "type" "str" 
   "int" "float" "bool" "list" "dict" "set" "tuple"))

; Constants
((identifier) @constant
 (#any-of? @constant "None" "True" "False" "__name__" "__main__"))

; Enhanced decorator support including module.decorator patterns
(decorator 
  "@" @punctuation.special
  (identifier) @function.decorator
  (#set! "priority" 130))

(decorator
  "@" @punctuation.special
  (attribute
    object: (identifier) @module
    attribute: (identifier) @function.decorator)
  (#set! "priority" 130))

; Async/await keywords
((identifier) @keyword.async
 (#any-of? @keyword.async "async" "await")
 (#set! "priority" 125))

; Function definitions with async
(function_definition
  "async" @keyword.async
  "def" @keyword.function
  name: (identifier) @function
  (#set! "priority" 120))

; Import statements
(import_statement
  "import" @keyword.import
  (#set! "priority" 125))

(import_from_statement
  "from" @keyword.import
  "import" @keyword.import
  (#set! "priority" 125))

; Module names in imports
(import_statement
  name: (dotted_name
    (identifier) @module))

(import_from_statement
  module_name: (dotted_name
    (identifier) @module))

; Aliased imports
(aliased_import
  name: (dotted_name
    (identifier) @module)
  alias: (identifier) @variable)

; Method calls with better highlighting
(call
  function: (attribute
    object: (identifier) @variable
    attribute: (identifier) @function.method)
  (#set! "priority" 120))

; Class definitions
(class_definition
  name: (identifier) @type.class
  (#set! "priority" 120))