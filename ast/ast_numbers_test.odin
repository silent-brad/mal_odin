package ast

import "../reader"
import "core:testing"

@(test)
test_parse_number :: proc(t: ^testing.T) {
	tokens := []reader.Atom{{type = .Number, value = "123"}}

	result := parse(tokens)
	defer destroy_result(&result)

	testing.expect(t, result.err.kind == .None)

	testing.expect(t, len(result.program.forms) == 1)

	testing.expect(t, result.program.forms[0].kind == .Number)
	testing.expect(t, result.program.forms[0].number == 123)
}
