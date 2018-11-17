defmodule BIP39Test do
  use ExUnit.Case
  doctest BIP39

  test "greets the world" do
    assert BIP39.hello() == :world
  end
end
