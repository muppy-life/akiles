defmodule Akiles.GroupsTest do
  use ExUnit.Case

  test "list_groups/0 works well" do
    assert {:ok, _data} = Akiles.Group.list_groups
  end

  test "get_group/1 works well" do
    assert {:ok, [group | _rest]} = Akiles.Group.list_groups
    assert {:ok, _data} = Akiles.Group.get_group(group.id)
  end

  test "Get_group/1 error well digested" do
    assert {:error, message} = Akiles.Group.get_group("nonValidID")
    assert String.contains?(message, "Elixir.Akiles.Group")
    assert String.contains?(message, "INVALID_REQUEST")
  end

  test "create_group/1 & delete_group/1 works well" do
    assert {:ok, group} = Akiles.Group.create_group(%{name: "Test Group"})
    assert {:ok, _group} = Akiles.Group.delete_group(group.id)
  end

  test "edit_group/2 errors well digested" do
    assert {:error, message} = Akiles.Group.edit_group("IdNotvalid", %{name: "New Name"})
    assert String.contains?(message, "Elixir.Akiles.Group")
    assert String.contains?(message, "INVALID_REQUEST")
  end
end
