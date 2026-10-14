default:
    @just --list

# Build all targets
build:
    odin build mal
    strip mal.bin

# Run the toy interpreter
run:
    odin run mal

# Run all tests
test:
    odin test mal
    odin test ast
    odin test eval
    odin test loader
    odin test reader
    odin test repl

fmt:
    # odin check *.odin
    # odin strip-semicolon *.odin
    odinfmt mal -w -config:odinfmt.json
    odinfmt ast -w -config:odinfmt.json
    odinfmt eval -w -config:odinfmt.json
    odinfmt loader -w -config:odinfmt.json
    odinfmt reader -w -config:odinfmt.json
    odinfmt repl -w -config:odinfmt.json
