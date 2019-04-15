defmodule GoParser do
  @moduledoc """
  Documentation for GoParser.
  """

  def load_dir(glob) do
    Path.wildcard(glob)
    |> Enum.map(&load_file(&1))
  end

  def load_file(filename) do
    case File.read(filename) do
      {:ok, sgf} ->
        load_string(sgf)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def load_string(string) do
    with {:ok, tokens, _} <- lex_string(string),
      {:ok, trees} <- :sgf_parser.parse(tokens)
    do
      {:ok, trees}
    else
      {:error, reason, _} -> {:error, reason}
      #_ -> {:error, "cannot process input"}
      any -> any
    end
  end

  defp lex_string(string) do
    string |> to_charlist |> :sgf_lexer.string
  end

  # Load file
  # Load string
  # Dump tree
  # Game info
  # Add parser (and remove trees)
end
