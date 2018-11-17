defmodule BIP39.Bits do
  @moduledoc """
  Module for converting binary to a list of integer numbers
  used as rows for the mnemonic code words
  """

  @doc """
  Loops through the bitstring and converts it to a bit list
  """
  @spec to_list(binary) :: list(integer)
  def to_list(binary) when is_binary(binary) do
    to_list(binary, [])
  end

  defp to_list(<<bit::size(1), bits::bitstring>>, acc) do
    to_list(bits, [bit | acc])
  end

  defp to_list(<<>>, acc), do: Enum.reverse(acc)

  @doc """
  Convers a binary list to a integer list
  """
  @spec to_int_list(list(binary)) :: list(number)
  def to_int_list(list) do
    list |> Enum.map(&binary_to_int/1)
  end

  @doc """
  Splits the given string into groups of 11 bits each encoding
  a number from 0-2047
  """
  @spec split_into_11_bit_groups(String.t) :: list(String.t)
  def split_into_11_bit_groups(string_bits) do
    split_into_11_bit_groups(string_bits, [])
  end
  def split_into_11_bit_groups(<<part::binary-11, rest::binary>>, acc) do
    split_into_11_bit_groups(rest, [part | acc])
  end
  def split_into_11_bit_groups("", acc), do: Enum.reverse(acc)

  @doc """
  Converts a binary to a integer
  """
  @spec binary_to_int(binary) :: list(number)
  defp binary_to_int(binary) do
    binary
    |> Integer.parse(2)
    |> elem(0)
  end

end
