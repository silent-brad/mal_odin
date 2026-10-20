package ast

import "../reader"
import "core:testing"

@(test)
test_unexpected_right_paren :: proc(t: ^testing.T) {
	tokens := []reader.Atom{{type = .Right_Paren, value = ")"}}

	result := parse(tokens)

	testing.expect(t, result.err.kind == .Unexpected_Right_Paren)
}

@(test)
test_unclosed_list :: proc(t: ^testing.T) {
	tokens := []reader.Atom {
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "+"},
		{type = .Number, value = "1"},
	}

	result := parse(tokens)
	defer destroy_result(&result)

	testing.expect(t, result.err.kind == .Unclosed_List)
}

@(test)
test_invalid_number :: proc(t: ^testing.T) {
	tokens := []reader.Atom{{type = .Number, value = "1.0"}}

	result := parse(tokens)
	defer destroy_result(&result)

	testing.expect(t, result.err.kind == .Invalid_Number)
}
