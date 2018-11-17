defmodule BIP39.Mnemonic do
  @moduledoc """
  Module for generating a Mnemonic phrase following the BIP-39 standard
  """

  @doc """
  Generates a phrase from a given list of indexes
  """
  @spec generate_phrase(list(number)) :: String.t
  def generate_phrase(indexes) do
    word_list = get_word_list()
    indexes
    |> Enum.map(&Enum.at(word_list, &1))
    |> Enum.join(" ")
  end

  @doc """
  Gets / reads word list from priv folder
  """
  @spec get_word_list :: list(String.t)
  def get_word_list do
    {:ok, word_list} =
      :bip39
      |> :code.priv_dir
      |> Path.join("wordlist.txt")
      |> File.read

    word_list
    |> String.split("\n")
  end
end
