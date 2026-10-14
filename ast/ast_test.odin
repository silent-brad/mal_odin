package ast

import "core:testing"
import "core:log"
import "./reader"

@(test)
test_ast :: proc(t: ^testing.T) {
  tokens := []Atom {
		{type = .LEFT_PAREN},
		{type = .SYMBOL, value = "+"},
		{type = .NUMBER, value = 1},
		{type = .NUMBER, value = 2},
		{type = .RIGHT_PAREN},
		{type = .STRING, value = "Hello!"},
		{type = .LEFT_PAREN},
		{type = .SYMBOL, value = "def"},
		{type = .IDENTIFIER, value = "x"},
		{type = .NUMBER, value = 3},
		{type = .RIGHT_PAREN},
	}
  ast := parse(tokens)
  defer delete(ast)


}
