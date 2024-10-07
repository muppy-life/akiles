defmodule Akiles.GadgetsTest do
  use ExUnit.Case
  alias Akiles.Gadget

  test "list_gadgets/0 works well" do
    {:ok, gadgets} = Gadget.list_gadgets()
    assert %Gadget{} = gadgets |> List.first()
  end

  test "get_gadget/1 works well" do
    {:ok, [gadget | _rest]} = Gadget.list_gadgets()
    {:ok, target} = Gadget.get_gadget(gadget.id)
    assert target == gadget
  end

  test "find_gadget/1 works well" do
    {:ok, target} = Gadget.find_gadget(name: "Controller 1")
    assert target.name == "Controller 1"
  end

  test "do_gadget_action/2 works well" do
    {:ok, [gadget | _rest]} = Gadget.list_gadgets()
    assert :ok == Gadget.do_gadget_action(gadget.id, "open")
  end
end
