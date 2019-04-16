# GoParser

## Description

Utility to parse sgf file into Tree/Node structure. 
It can be used to extract a list of list of actions from file, and push them into Go.Board.

It uses Erlang lexer (but not yacc) for tokenization. The lexer is a slightly modified version of [Trevoke/sgf-elixir](https://github.com/Trevoke/sgf-elixir), lexer/yacc branch.

The purpose of this project is to use Tree/Node for sgf editing. 

TODO: 
  * Add to_sgf for Tree and Node
  * Build the sgf editor

## References
Various references used in the project.
  * [leex](http://erlang.org/doc/man/leex.html)
  * [sgf-elixir](https://github.com/Trevoke/sgf-elixir)
  * [sgf test file](http://www.red-bean.com/sgf/examples/)
  * [Kogo's Joseki Dictionary](http://waterfire.us/joseki.htm)

## Installation

This package is not yet available on hex. Please use :


```elixir
def deps do
  [{:go_parser, github: "kokolegorille/go_parser", tag: "v0.1.0"}]
end
```

## Usage

There are multiples sample files in test/fixtures
  * example.sgf
  * ff4_ex.sgf
+ KJD dictionary
+ sample files from ff4 spec page
+ Bogus file to test Error path

