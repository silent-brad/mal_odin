package ast

import "../reader"
import "core:testing"

@(test)
test_parse_nested_list :: proc(t: ^testing.T) {
	tokens := []reader.Atom {
		{type = reader.Token.Left_Paren, value = "("},
		{type = reader.Token.Symbol, value = "+"},
		{type = reader.Token.Number, value = "1"},
		{type = reader.Token.Left_Paren, value = "("},
		{type = reader.Token.Symbol, value = "*"},
		{type = reader.Token.Number, value = "2"},
		{type = reader.Token.Number, value = "3"},
		{type = reader.Token.Right_Paren, value = ")"},
		{type = reader.Token.Right_Paren, value = ")"},
	}

	result := parse(tokens)
	defer destroy_result(&result)

	testing.expect(t, result.err.kind == .None)

	testing.expect(t, result.program.forms[0].kind == .List)
	testing.expect(t, len(result.program.forms[0].children) == 3)

	testing.expect(t, result.program.forms[0].children[0].kind == .Symbol)
	testing.expect(t, result.program.forms[0].children[0].text == "+")

	testing.expect(t, result.program.forms[0].children[1].kind == .Number)
	testing.expect(t, result.program.forms[0].children[1].number == 1)

	testing.expect(t, result.program.forms[0].children[2].kind == .List)
	testing.expect(t, len(result.program.forms[0].children[2].children) == 3)

	testing.expect(
		t,
		result.program.forms[0].children[2].children[0].kind == .Symbol,
	)
	testing.expect(
		t,
		result.program.forms[0].children[2].children[0].text == "*",
	)

	testing.expect(
		t,
		result.program.forms[0].children[2].children[1].kind == .Number,
	)
	testing.expect(
		t,
		result.program.forms[0].children[2].children[1].number == 2,
	)

	testing.expect(
		t,
		result.program.forms[0].children[2].children[2].kind == .Number,
	)
	testing.expect(
		t,
		result.program.forms[0].children[2].children[2].number == 3,
	)
}
