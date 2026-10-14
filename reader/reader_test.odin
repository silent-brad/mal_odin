package reader

import "core:testing"

@(test)
test_tokenize :: proc(t: ^testing.T) {
	input := """
    ; Comment
    (+ 1 23)
    "Hello!"
    (def x 3)
  """

	expected := []Atom {
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "+"},
		{type = .Number, value = "1"},
		{type = .Number, value = "23"},
		{type = .Right_Paren, value = ")"},
		{type = .String, value = "Hello!"},
		{type = .Left_Paren, value = "("},
		{type = .Identifier, value = "def"},
		{type = .Identifier, value = "x"},
		{type = .Number, value = "3"},
		{type = .Right_Paren, value = ")"},
	}

	actual := tokenize(input)
	defer delete(actual)

	testing.expectf(
		t,
		len(actual) == len(expected),
		"token count mismatch: expected %d, got %d",
		len(expected),
		len(actual),
	)
	// Do not index expected beyond its end if the length assertion fails
	count := min(len(actual), len(expected))
	for i in 0 ..< count {
		testing.expectf(
			t,
			actual[i].type == expected[i].type,
			"token %d type mismatch: expected %v, got %v",
			i,
			expected[i].type,
			actual[i].type,
		)
		testing.expectf(
			t,
			actual[i].value == expected[i].value,
			"token %d value mismatch: expected %q, got %q",
			i,
			expected[i].value,
			actual[i].value,
		)
	}
}

@(test)
test_tokenize_escaped_quote :: proc(t: ^testing.T) {
	input := `"Hello, \"Odin\"!"`
	expected := []Atom{{type = .String, value = `Hello, \"Odin\"!`}}
	actual := tokenize(input)
	defer delete(actual)
	testing.expectf(
		t,
		len(actual) == len(expected),
		"token count mismatch: expected %d, got %d",
		len(expected),
		len(actual),
	)
	count := min(len(actual), len(expected))
	for i in 0 ..< count {
		testing.expectf(
			t,
			actual[i] == expected[i],
			"token %d mismatch: expected %v, got %v",
			i,
			expected[i],
			actual[i],
		)
	}
}
