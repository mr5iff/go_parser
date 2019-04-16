defmodule GoParserTest do
  use ExUnit.Case
  # doctest GoParser

  # PARSING STRING
  # Sample strings found at https://www.red-bean.com/sgf/var.htm

  test "can parse a string" do
    string = "(;FF[4]GM[1]SZ[19];B[aa];W[bb];B[cc];W[dd];B[ad];W[bd])"
    assert {:ok, _} = GoParser.load_string(string)
  end

  test "can parse a string with one variation at move 3" do
    string = "(;FF[4]GM[1]SZ[19];B[aa];W[bb](;B[cc];W[dd];B[ad];W[bd])(;B[hh];W[hg]))"
    assert {:ok, _} = GoParser.load_string(string)
  end

  test "can parse a string with two variations at move 3" do
    string = "(;FF[4]GM[1]SZ[19];B[aa];W[bb](;B[cc]N[Var A];W[dd];B[ad];W[bd])(;B[hh]N[Var B];W[hg])(;B[gg]N[Var C];W[gh];B[hh];W[hg];B[kk]))"
    assert {:ok, _} = GoParser.load_string(string)
  end

  test "can parse a string with two variations at different moves" do
    string = "(;FF[4]GM[1]SZ[19];B[aa];W[bb](;B[cc];W[dd](;B[ad];W[bd])(;B[ee];W[ff]))(;B[hh];W[hg]))"
    assert {:ok, _} = GoParser.load_string(string)
  end

  test "can parse a string with variation of a variation" do
    string = "(;FF[4]GM[1]SZ[19];B[aa];W[bb](;B[cc]N[Var A];W[dd];B[ad];W[bd])(;B[hh]N[Var B];W[hg])(;B[gg]N[Var C];W[gh];B[hh](;W[hg]N[Var A];B[kk])(;W[kl]N[Var B])))"
    assert {:ok, _} = GoParser.load_string(string)
  end

  # PARSING FILE

  test "can parse a file" do
    file = "./test/fixtures/example.sgf"
    assert {:ok, _} = GoParser.load_file(file)
  end

  test "can parse KJD dictionary" do
    file = "./test/fixtures/2015_KJD.sgf"
    assert {:ok, _} = GoParser.load_file(file)
  end

  test "can parse ff4 example file" do
    file = "./test/fixtures/ff4_ex.sgf"
    assert {:ok, _} = GoParser.load_file(file)
  end

  # PARSING BOGUS FILE

  test "fail to parse bogus file" do
    file = "./test/fixtures/bogus.txt"
    assert {:error, _} = GoParser.load_file(file)
  end

  # PARSING DIRECTORY

  test "can parse directory" do
    directory = "./test/fixtures/*.sgf"
    list = GoParser.load_dir(directory)

    # assert all list elements are a tuple starting with ok
    assert Enum.all?(list, fn {:ok, _} ->  true end)
  end
end
