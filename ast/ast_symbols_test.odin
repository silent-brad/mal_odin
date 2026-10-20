package ast

import "../reader"
import "core:testing"

@(test)
test_parse_symbol :: proc(t: ^testing.T) {
	tokens := []reader.Atom {
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "+"},
		{type = .Number, value = "1"},
		{type = .Number, value = "23"},
		{type = .Right_Paren, value = ")"},
	}

	// expected := Program {
	//   forms = []Ast {
	//
	//   {type = .List, children = {
	//     {type = .Symbol, text = "+"},
	//     {type = .Number, number = 1},
	//     {type = .Number, number = 23},
	//   },
	//   }
	// }

	result := parse(tokens)
	defer destroy_result(&result)

	testing.expect(t, result.err.kind == .None)

	testing.expect(t, result.program.forms[0].kind == .List)
	testing.expect(t, len(result.program.forms[0].children) == 3)

	testing.expect(t, result.program.forms[0].children[0].kind == .Symbol)
	testing.expect(t, result.program.forms[0].children[0].text == "+")

	testing.expect(t, result.program.forms[0].children[1].kind == .Number)
	testing.expect(t, result.program.forms[0].children[1].number == 1)

	testing.expect(t, result.program.forms[0].children[2].kind == .Number)
	testing.expect(t, result.program.forms[0].children[2].number == 23)
}
