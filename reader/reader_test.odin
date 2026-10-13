package reader

import "core:testing"
import "core:log"

@(test)
test_tokenize :: proc(t: ^testing.T) {
	input := """
    ; Comment
    (+ 1 2)
    "Hello!"
    (def x 3)
  """
	expected := []Atom {
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
	actual := tokenize(input)
  defer delete(actual)
  log.info(actual)
	testing.expect(t, len(actual) == len(expected), "Tokenizer failed")
}
