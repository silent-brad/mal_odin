package reader

import "core:testing"

expect_tokens_equal :: proc(t: ^testing.T, actual: []Atom, expected: []Atom) {
	testing.expectf(
		t,
		len(actual) == len(expected),
		"token count mismatch: expected %d, got %d",
		len(expected),
		len(actual),
	)

	// Avoid indexing beyond either slice if the token count is incorrect.
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
test_tokenize_comment :: proc(t: ^testing.T) {
	input := "; This entire line is a comment"

	expected := []Atom{}

	actual := tokenize(input)
	defer delete(actual)

	expect_tokens_equal(t, actual[:], expected)
}

@(test)
test_tokenize_arithmetic_expression :: proc(t: ^testing.T) {
	input := "(+ 1 23)"

	expected := []Atom {
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "+"},
		{type = .Number, value = "1"},
		{type = .Number, value = "23"},
		{type = .Right_Paren, value = ")"},
	}

	actual := tokenize(input)
	defer delete(actual)

	expect_tokens_equal(t, actual[:], expected)
}

@(test)
test_tokenize_string :: proc(t: ^testing.T) {
	input := `"Hello!"`

	expected := []Atom{{type = .String, value = "Hello!"}}

	actual := tokenize(input)
	defer delete(actual)

	expect_tokens_equal(t, actual[:], expected)
}

@(test)
test_tokenize_definition :: proc(t: ^testing.T) {
	input := "(def x 3)"

	expected := []Atom {
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "def"},
		{type = .Symbol, value = "x"},
		{type = .Number, value = "3"},
		{type = .Right_Paren, value = ")"},
	}

	actual := tokenize(input)
	defer delete(actual)

	expect_tokens_equal(t, actual[:], expected)
}

@(test)
test_tokenize_function_definition :: proc(t: ^testing.T) {
	input := "(def add (a b) (+ a b))"

	expected := []Atom {
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "def"},
		{type = .Symbol, value = "add"},
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "a"},
		{type = .Symbol, value = "b"},
		{type = .Right_Paren, value = ")"},
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "+"},
		{type = .Symbol, value = "a"},
		{type = .Symbol, value = "b"},
		{type = .Right_Paren, value = ")"},
		{type = .Right_Paren, value = ")"},
	}

	actual := tokenize(input)
	defer delete(actual)

	expect_tokens_equal(t, actual[:], expected)
}

@(test)
test_tokenize_function_call_with_trailing_comment :: proc(t: ^testing.T) {
	input := "(add 1 2) ; Another comment"

	expected := []Atom {
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "add"},
		{type = .Number, value = "1"},
		{type = .Number, value = "2"},
		{type = .Right_Paren, value = ")"},
	}

	actual := tokenize(input)
	defer delete(actual)

	expect_tokens_equal(t, actual[:], expected)
}

@(test)
test_tokenize_nested_expression :: proc(t: ^testing.T) {
	input := "(* 2 (- x 5))"

	expected := []Atom {
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "*"},
		{type = .Number, value = "2"},
		{type = .Left_Paren, value = "("},
		{type = .Symbol, value = "-"},
		{type = .Symbol, value = "x"},
		{type = .Number, value = "5"},
		{type = .Right_Paren, value = ")"},
		{type = .Right_Paren, value = ")"},
	}

	actual := tokenize(input)
	defer delete(actual)

	expect_tokens_equal(t, actual[:], expected)
}

@(test)
test_tokenize_multiline_input :: proc(t: ^testing.T) {
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
		{type = .Symbol, value = "def"},
		{type = .Symbol, value = "x"},
		{type = .Number, value = "3"},
		{type = .Right_Paren, value = ")"},
	}

	actual := tokenize(input)
	defer delete(actual)

	expect_tokens_equal(t, actual[:], expected)
}

@(test)
test_tokenize_escaped_quote :: proc(t: ^testing.T) {
	input := `"Hello, \"Odin\"!"`

	expected := []Atom{{type = .String, value = `Hello, \"Odin\"!`}}

	actual := tokenize(input)
	defer delete(actual)

	expect_tokens_equal(t, actual[:], expected)
}

@(test)
test_tokenize_keyword :: proc(t: ^testing.T) {
	input := `:abc :def :ghi`

	expected := []Atom {
		{type = .Symbol, value = ":abc"},
		{type = .Symbol, value = ":def"},
		{type = .Symbol, value = ":ghi"},
	}

	actual := tokenize(input)
	defer delete(actual)

	expect_tokens_equal(t, actual[:], expected)
}
