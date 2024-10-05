; notes
; things that will decrease (or negate)
; indent.branch if the line above is the starting row of the range
; indent.dedent if the line above is NOT the starting row of the range
; indent.close_delimiter will cancel an indent.opening delimiter, without an open_delimiter it will do nothing

; indent.end is a bit funny
; if we are in a new line (a common occurence) then we get the last node above us
; however, if that node has indent.end, we will instead get the first node in our current line, 
; i.e. the first node of the enclosing range
; note that indent.end only kicks in if it is the absolute last node in the range, named or not
; note, if you misspell the capture name indent.lua will crash

[
  (module_defn)
  (value_declaration)
  (paren_expression)
  (brace_expression)
  (anon_record_expression)
  (list_expression)
  (array_expression)
  (while_expression)
  (if_expression)
  (elif_expression)
  (rule)
] @indent.begin

((value_declaration
   _+)
  ";" @indent.end .)

((rules) @indent.begin
 (#set! indent.start_at_same_line))

; The following seem to work well for cramped style
((application_expression) @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))

((list_expression) @indent.align
  (#set! indent.increment 2)
  (#set! indent.open_delimiter "[")
  (#set! indent.close_delimiter "]"))

((field_initializers) @indent.align
  (#set! indent.increment 2)
  (#set! indent.open_delimiter "{")
  (#set! indent.close_delimiter "}"))

((brace_expression) @indent.align
  (#set! indent.increment 2)
  (#set! indent.open_delimiter "{")
  (#set! indent.close_delimiter "}"))

((paren_expression) @indent.align
  (#set! indent.increment 2)
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))

((anon_record_expression) @indent.align
  (#set! indent.increment 2)
  (#set! indent.open_delimiter "{|")
  (#set! indent.close_delimiter "|}"))

((array_expression) @indent.align
  (#set! indent.increment 2)
  (#set! indent.open_delimiter "{|")
  (#set! indent.close_delimiter "|}"))

; this doesn't work because indent.lua fetches all nodes to check for indent.end
; (value_declaration 
;   (function_or_value_defn
;     body: (const(string)) @indent.end))

; this should work for ints and such
(value_declaration
        (function_or_value_defn
          body: (const
            ((_) @indent.end))))

; this doesn't work because the const is not the last node fetched
; (value_declaration
;         (function_or_value_defn
;           body: (const) @indent.end))
; this might work but only in conjunction with indent.begin above
; actually this does not work, it dedents too much
; (value_declaration
;         (function_or_value_defn
;           body: (const) @indent.dedent))
; this works
; (value_declaration
;         (function_or_value_defn
;           body: (const
;             ((int) @indent.end))))

; this is needed because lua fetches all nodes and the last node is then the later ""
(value_declaration
        (function_or_value_defn
          body: (const
            (string
              "\""
              "\"" @indent.end))))
; this doesn't seem to work because the block delimiter is not named or at least somehow invisible
; or maybe there is another reason?
; It could also  be because it's not part of the enclosing range

((file) @indent.zero)

; ((";;") @indent.end)

(ERROR
  .
  [
   "module"
   "do"
  ]) @indent.begin

[
 (string)
 (line_comment)
 (block_comment)
 (xml_doc)
] @indent.auto
