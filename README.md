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

There are 2 sample files in test/fixtures
  * example.sgf
  * ff4_ex.sgf

Extract branches and actions

```elixir
iex> alias GoParser.{Parser, Tree, Node}

  # to see tokens, for fun
iex> tokens = Parser.get_tokens "test/fixtures/example.sgf"

  # load tree
iex> tree = Parser.parse "test/fixtures/example.sgf"

  # To get all the branches, You collect the leaves, and collect for each ancestors_and_self
  # Useful for multi-branches sgf... like Kogo's Joseki Dictionary
iex> branches = Tree.leaves(tree) |> Enum.map(& Tree.ancestors_and_self(tree, &1.id))
iex> branch = branches |> Enum.at(0)
iex> actions = branch |> Enum.map(&Node.get_actions(&1)) |> Enum.reject(& &1 === [])
```

see test for more usage.

## Usage with elixir_go

If used with [elixir_go](https://hex.pm/packages/elixir_go), You can replay moves on board.

Here is an example with a simple action pusher... Name it, place it where You want and try it.

```elixir
defmodule ActionsPusher do
  alias Go.Board
  require Logger
  
  # actions is a list of list!
  def push(actions) do
    board_or_error = actions 
    |> Enum.reduce({:ok, Board.new}, fn(turn_actions, acc) -> 
      turn_actions 
      |> Enum.reduce(acc, fn(action, acc2) -> 
        apply_action(acc2, action)
      end)
    end)
    
    case board_or_error do
      {:ok, board} -> board
      {:error, _reason} -> :error
    end
  end
  
  def apply_action({:ok, board} = _state, action) do
    case action do
      {:pass, color} ->
        board |> Board.pass(color)
      {:add_move, move} ->
        board |> Board.add_move( move)
      {:place_stone, coordinate, color} ->
        board |> Board.place_stone(coordinate, color)
      {:place_stones, list_of_coordinates, color} ->
        board |> Board.place_stones(list_of_coordinates, color)
      {:remove_stone, coordinate} ->
        board |> Board.remove_stone(coordinate)
      {:remove_stones, list_of_coordinates} ->
        board |> Board.remove_stones(list_of_coordinates)
      {unknown_action, _} -> {:error, "unknown action #{unknown_action}"}
      {unknown_action, _, _} -> {:error, "unknown action #{unknown_action}"}
    end
  end
  
  def apply_action({:error, reason} = _state, _action) do
    {:error, reason}
  end
end
```

Push actions into Go.Board

```elixir
iex> alias Go.Board
iex> alias Go.Board.Tools
iex> board = ActionsPusher.push(actions) 
iex> board |> Board.to_ascii_board |> IO.puts
+O++O++++++++++++++
O+OOXXX+++++++++XXX
XO++OOOXXO+XX+++XOX
+XO+O+OOXO+XOXXXOOO
+O++++OXXXXXOO+XXO+
+OO+OOXX+OXO++XXO+O
++OOOOOX++O+O+XO+OX
+O+O+XOXOOOO++XOOOX
++OXO+XOOXXXXX+OXXX
OOOXXOXOOOXXOXXXXO+
+XXXOO+OXXOOO+OXXOO
X+XXXOOOXOO++OOOXXO
+X+OOXXOXXXOO+XXOOO
XOOOXX+XXX+XXXXOO++
XXX+O+X+XX+X++XO+++
OOXXXXOXX+++++XXO++
+OOOOOOOXXX++XOOO++
+O+OXOOXX++XXXOXOO+
++OXXXXX+++++XXXXO+
```

Extract all positions from board.history

```elixir
iex> board.history |> Enum.map(&Tools.fengo_to_ascii_board(&1)) |> Enum.join("\n\n") |> IO.puts
```

Extract all moves

```elixir
iex> board.moves
```

## Note for KJD

At the moment, about 7400 branches over 7700 from [Kogo's Joseki Dictionary](http://waterfire.us/joseki.htm) are checked correctly.

Remaining branches are on error, mostly because turn is not set correctly after stone placements. 

TODO: Set "PL" property on the faulty nodes.
