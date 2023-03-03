defmodule AkilesTest do
  use ExUnit.Case
  doctest Akiles

  test "greets the world" do
    assert Akiles.hello() == :world
  end
end
