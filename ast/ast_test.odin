package ast

import "core:testing"

@(test)
test_ast :: proc(t: ^testing.T) {
  ast := parse("(+ 1 2)")
  defer delete(ast)
}
