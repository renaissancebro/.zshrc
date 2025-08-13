; extends

; HTML tag names with enhanced styling
(tag_name) @tag (#set! "priority" 120)
(end_tag (tag_name) @tag (#set! "priority" 120))

; Self-closing tags
(self_closing_tag (tag_name) @tag (#set! "priority" 120))

; HTML attributes with different colors for names and values
(attribute_name) @tag.attribute (#set! "priority" 115)
(attribute_value) @string (#set! "priority" 110)
(quoted_attribute_value) @string (#set! "priority" 110)

; Tag delimiters with specific colors
(start_tag 
  "<" @tag.delimiter
  ">" @tag.delimiter
  (#set! "priority" 125))

(end_tag
  "</" @tag.delimiter
  ">" @tag.delimiter
  (#set! "priority" 125))

(self_closing_tag
  "<" @tag.delimiter
  "/>" @tag.delimiter
  (#set! "priority" 125))

; Special HTML elements
((tag_name) @tag.builtin 
  (#any-of? @tag.builtin
    "html" "head" "body" "title" "meta" "link" "script" "style"
    "div" "span" "p" "h1" "h2" "h3" "h4" "h5" "h6"
    "a" "img" "ul" "ol" "li" "table" "tr" "td" "th"
    "form" "input" "button" "select" "option" "textarea"))

; DOCTYPE declaration
(doctype) @keyword.directive (#set! "priority" 125)

; HTML comments
(comment) @comment (#set! "priority" 115)

; Text content
(text) @none (#set! "priority" 90)

; Attribute operators
(attribute "=" @operator (#set! "priority" 110))