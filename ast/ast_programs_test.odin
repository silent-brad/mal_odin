package ast

import "../reader"
import "core:testing"

// @(test)
// test_parse_function_definition :: proc(t: ^testing.T) {
// 	tokens := []reader.Atom{
//     {type = .Left_Paren, value = "("},
//     {type = .Symbol, value = "define"},
//     {type = .Symbol, value = "add"},
//     {type = .Left_Paren, value = "("},
//     {type = .Symbol, value = "a"},
//     {type = .Symbol, value = "b"},
//     {type = .Right_Paren, value = ")"},
//     {type = .Left_Paren, value = "("},
//     {type = .Symbol, value = "+"},
//     {type = .Symbol, value = "a"},
//     {type = .Symbol, value = "b"},
//     {type = .Right_Paren, value = ")"},
//     {type = .Right_Paren, value = ")"},
//   }
//
// 	result := parse(tokens)
//
// 	testing.expect(t, result.err == nil)
// 	testing.expect(t, result.program.kind == .Function_Definition)
// 	testing.expect(t, result.program.function_definition.name == "+")
// 	testing.expect(t, result.program.function_definition.parameters == ["a", "b"])
// 	testing.expect(t, result.program.function_definition.body == ["a", "b"])
// }
//
// @(test)
// test_parse_multiple_forms :: proc(t: ^testing.T) {
// 	tokens := []reader.Atom{
//     {type = .Right_Paren, value = ")"},
//   }
//
// 	result := parse(tokens)
//
// 	testing.expect(t, result.err.kind == .Unexpected_Right_Paren)
// }
//
// @(test)
// test_arithmetic_expression :: proc(t: ^testing.T) {
// 	tokens := []reader.Atom{
//     {type = .Right_Paren, value = ")"},
//   }
//
// 	result := parse(tokens)
//
// 	testing.expect(t, result.err.kind == .Unexpected_Right_Paren)
// }
