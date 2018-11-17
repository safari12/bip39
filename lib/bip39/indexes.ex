defmodule BIP39.Indexes do
  @moduledoc """
  Module for generating random indexes used by the mnemnonic module
  to generate a phrase from the wordlist

  The mnemonic must encode entropy in a multiple of 32 bits.
  With more entropy security, the sentence length increases.
  We refer to the initial entropy length as ENT. The allowed
  size of ENT is 128-256 bits

  First, an initial entropy of ENT bits is generated. A checksum
  is generated by taking the first

  ENT / 32

  bits of its SHA256 hash. This checksum is appended to the end
  of the initial entropy. Next, these concatentated bits are split
  into groups of 11 bits, each encoding a number from 0-2047, serving
  as an index into a wordlist. Finally, we convert these numbers into
  words and use the joined words as a mnemonic sentence / phrase.
  The following table describes the relation between the initial
  entropy length (ENT), the checksum length (CS) and the length
  of the generated mnemonic sentence (MS) in words.

  ## Example
      CS = ENT / 32
      MS = (ENT + CS) / 11
      |  ENT  | CS | ENT+CS |  MS  |
      +-------+----+--------+------+
      |  128  |  4 |   132  |  12  |
      |  160  |  5 |   165  |  15  |
      |  192  |  6 |   198  |  18  |
      |  224  |  7 |   231  |  21  |
      |  256  |  8 |   264  |  24  |
  """

  alias BIP39.Bits

  @doc """
  Generates random numbers (indexes) using entropy for
  guaranteed randomness
  """

  @spec generate_indexes(number) :: list(number)
  def generate_indexes(entropy_byte_size)
    when entropy_byte_size >= 16 and entropy_byte_size <= 32
  do
    entropy = generate_entropy(entropy_byte_size)
    checksum = generate_checksum(entropy, entropy_byte_size)

    entropy
    |> Bits.to_list
    |> Enum.join
    |> Kernel.<>(checksum)
    |> Bits.split_into_11_bit_groups
    |> Bits.to_int_list
  end

  defp generate_checksum(entropy, entropy_byte_size) do
    entropy_bit_size = entropy_byte_size * 8
    checksum_length = trunc(entropy_bit_size / 32)

    entropy
    |> SCrypto.sha256
    |> Bits.to_list
    |> Enum.join
    |> String.slice(0..(checksum_length - 1))
  end

  defp generate_entropy(entropy_byte_size) do
    :crypto.strong_rand_bytes(entropy_byte_size)
  end
end
