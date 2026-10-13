package reader

/**
 * Tokenizer for S-expressions
 *
 * Turns lines into tokens
 */

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:unicode"
import "core:unicode/utf8"
import "core:log"

Token :: enum {
	SYMBOL,
  IDENTIFIER,
	NUMBER,
	STRING,
	LEFT_PAREN,
	RIGHT_PAREN,
}

Value :: union {
	int,
	rune,
	string,
}

Atom :: struct {
	type:  Token,
	value: Value,
}

tokenize :: proc(input: string, alloc := context.allocator) -> [dynamic]Atom {
  tokens := make([dynamic]Atom, alloc)
	for i := 0; i < len(input); i += 1 {
    char := utf8.rune_at(input, i)
		switch char {
    case ';':
      // Go until end of line
      for ; i < len(input); i += 1 {
        if input[i] == '\n' do break
      }
		case '(':
			append(&tokens, Atom{type = .LEFT_PAREN})
		case ')':
			append(&tokens, Atom{type = .RIGHT_PAREN})
		case ' ', '\t', '\n':
      // Ignore whitespace
    case '~': // Negative number
      i += 1
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			// Check if next character is number
      numbers := strings.builder_make(alloc)

      // Check if number is negative
      // if utf8.rune_at(input, i - 1) == '~' do strings.write_rune(&numbers, '-')

      strings.write_rune(&numbers, char)
      for ; i < len(input); i += 1 {
        new_char := utf8.rune_at(input, i + 1)
        is_digit := unicode.is_digit(new_char)
        if !is_digit do break
        strings.write_rune(&numbers, new_char)
      }

      // TODO: decimal?

      number, _ := strconv.parse_int(strings.to_string(numbers))

			append(&tokens, Atom{type = .NUMBER, value = number})
      strings.builder_destroy(&numbers)
    case '"':
      new_string := strings.builder_make(alloc)
      i += 1
      for ; i < len(input); i += 1 {
        char := utf8.rune_at(input, i)
        // Add string escape
        // log.info(char)
        // if char == '\\' && utf8.rune_at(input, i + 1) == '"' {
        //   strings.write_rune(&new_string, '"')
        //   i += 2
        //   continue
        // }
        if char == '"' {
          i += 1
          break
        }
        strings.write_rune(&new_string, char)
      }
      append(&tokens, Atom{type = .STRING, value = strings.to_string(new_string)})
      strings.builder_destroy(&new_string)
    // TODO: Make sure you add '-' and '_'
    case 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
         'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z':
      identifier := strings.builder_make(alloc)
      strings.write_rune(&identifier, char)
      for ; i < len(input); i += 1 {
        char = utf8.rune_at(input, i + 1)
        is_alpha := unicode.is_alpha(char)
        if !is_alpha do break
        strings.write_rune(&identifier, char)
      }
      log.info(strings.to_string(identifier))
      append(&tokens, Atom{type = .IDENTIFIER, value = strings.to_string(identifier)})
      strings.builder_destroy(&identifier)
		case '+', '-', '*', '/', '=':
			append(&tokens, Atom{type = .SYMBOL, value = char})
		case:
			// Default?
			fmt.println("Unknown character: {}", char)
		}
	}
	return tokens
}
