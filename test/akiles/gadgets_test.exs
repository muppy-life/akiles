defmodule Akiles.GadgetsTest do
  use ExUnit.Case
  alias Akiles.Gadget

  test "list_gadgets/0 works well" do
    assert {:ok, []} = Gadget.list_gadgets
  end
end
