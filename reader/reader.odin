package reader

/**
 * Tokenizer for S-expressions.
 *
 * Token values are slices of the original input. Therefore, the input string
 * must remain alive for as long as the returned tokens are used.
 */

import "core:unicode"
import "core:unicode/utf8"

Token :: enum {
	Symbol,
	Number,
	String,
	Left_Paren,
	Right_Paren,
}

Atom :: struct {
	type:  Token,
	value: string,
}

/**
 * Decode the rune starting at byte offset `i` without advancing.
 *
 * The returned width is measured in bytes.
 */
peek_rune :: proc(input: string, i: int) -> (r: rune, width: int) {
	if i >= len(input) do return 0, 0
	return utf8.decode_rune(input[i:])
}

/**
 * Decode the rune starting at byte offset `i`, then advance `i`
 * by the rune's UTF-8 byte width.
 */
next_rune :: proc(input: string, i: ^int) -> (r: rune, width: int) {
	r, width = peek_rune(input, i^)
	i^ += width; return
}

/**
 * Determine whether a rune may continue an identifier.
 *
 * Lisp identifiers commonly allow letters, digits, underscores, and
 * hyphens after the first character.
 */
is_identifier_continue :: proc(r: rune) -> bool {
	return unicode.is_alpha(r) || unicode.is_digit(r) || r == '_' || r == '-'
}

/**
 * Tokenize an S-expression.
 *
 * The returned dynamic array owns only its Atom storage. Each Atom.value
 * points into `input`, so destroying the token array does not require
 * deleting individual token values.
 */
tokenize :: proc(
	input: string,
	allocator := context.allocator,
) -> [dynamic]Atom {
	tokens := make([dynamic]Atom, allocator)
	i := 0
	for i < len(input) {
		r, width := peek_rune(input, i)
		// Prevent an infinite loop if decoding ever returns no progress.
		if width <= 0 { break }
		switch r {
		case ';':
			// Skip everything through the next newline.
			i += width
			for i < len(input) {
				comment_rune, comment_width := peek_rune(input, i)
				if comment_width <= 0 do break
				i += comment_width
				if comment_rune == '\n' do break
			}
		case ' ', '\t', '\n', '\r': i += width
		case '(':
			append(
				&tokens,
				Atom{type = .Left_Paren, value = input[i:i + width]},
			)
			i += width
		case ')':
			append(
				&tokens,
				Atom{type = .Right_Paren, value = input[i:i + width]},
			)
			i += width
		case '"':
			// Exclude the surrounding quotes from the token value.
			i += width
			start := i
			for i < len(input) {
				string_rune, string_width := peek_rune(input, i)
				if string_width <= 0 do break
				if string_rune == '"' do break
				// Skip an escaped rune so \" does not terminate the string.
				// Escapes remain encoded in the source slice. They can be
				// interpreted later when constructing the AST value.
				if string_rune == '\\' {
					i += string_width
					if i < len(input) {
						_, escaped_width := peek_rune(input, i)
						if escaped_width <= 0 do break
						i += escaped_width
					}
					continue
				}
				i += string_width
			}
			append(&tokens, Atom{type = .String, value = input[start:i]})
			// Consume the closing quote, if one exists.
			if i < len(input) {
				closing_rune, closing_width := peek_rune(input, i)
				if closing_rune == '"' do i += closing_width
			}
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			start := i
			i += width
			for i < len(input) {
				number_rune, number_width := peek_rune(input, i)
				if number_width <= 0 || !unicode.is_digit(number_rune) do break
				i += number_width
			}
			append(&tokens, Atom{type = .Number, value = input[start:i]})
		case '+', '-', '*', '/', '=':
			start := i
			i += width
			append(&tokens, Atom{type = .Symbol, value = input[start:i]})

		case: if unicode.is_alpha(r) || r == '_' || r == ':' {
					start := i
					i += width
					for i < len(input) {
						symbol_rune, symbol_width := peek_rune(input, i)
						if symbol_width <= 0 || !is_identifier_continue(symbol_rune) do break
						i += symbol_width
					}
					append(
						&tokens,
						Atom{type = .Symbol, value = input[start:i]},
					)
				} else do i += width // Unknown rune. Consume it so the tokenizer always progresses.
		}
	}
	return tokens
}
