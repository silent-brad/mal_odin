package ast

import "../reader"

Ast_Kind :: enum {
	Number,
	String,
	Symbol,
	List,
}

Ast :: struct {
	kind:     Ast_Kind,
	text:     string,
	number:   int,
	children: [dynamic]Ast,
}

Program :: struct {
	forms: [dynamic]Ast,
}

Parse_Error_Kind :: enum {
	None,
	Unexpected_Right_Paren,
	Unclosed_List,
	Invalid_Number,
}

Parse_Error :: struct {
	kind:        Parse_Error_Kind,
	token_index: int,
	message:     string,
}

Parse_Result :: struct {
	program: Program,
	err:     Parse_Error,
}

destroy_ast :: proc(node: ^Ast) {
	for &child in node.children {
		destroy_ast(&child)
	}
	delete(node.children)
}

destroy_program :: proc(program: ^Program) {
	for &form in program.forms {
		destroy_ast(&form)
	}
	delete(program.forms)
}

destroy_result :: proc(result: ^Parse_Result) {
	destroy_program(&result.program)
}

parse :: proc(
	tokens: []reader.Atom,
	alloc := context.allocator,
) -> Parse_Result {
	_ = tokens
	_ = alloc

	return Parse_Result{program = Program{}, err = Parse_Error{kind = .None}}
}
