defmodule GoParser do
  @moduledoc """
  Documentation for GoParser.
  """

  @doc ~S"""
  Parse directory and collect results.
  """
  def load_dir(glob) do
    Path.wildcard(glob)
    |> Enum.map(&load_file(&1))
  end

  @doc ~S"""
  Parse file and returns {:ok, trees}.
  """
  def load_file(filename) do
    case File.read(filename) do
      {:ok, sgf} ->
        load_string(sgf)
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc ~S"""
  Parse string and returns {:ok, trees}.
  """
  def load_string(string) do
    with {:ok, tokens, _} <- lex_string(string),
      {:ok, trees} <- :sgf_parser.parse(tokens)
    do
      {:ok, trees}
    else
      {:error, reason, _} -> {:error, reason}
      any -> any
    end
  end

  defp lex_string(string) do
    string
    |> to_charlist
    |> :sgf_lexer.string
  end
end
