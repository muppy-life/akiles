defmodule Akiles.GroupsTest do
  use ExUnit.Case
  alias Akiles.Group

  test "list_groups/0 works well" do
    assert {:ok, _data} = Group.list_groups
  end

  test "get_group/1 works well" do
    assert {:ok, [group | _rest]} = Group.list_groups
    assert {:ok, _data} = Group.get_group(group.id)
  end

  test "Get_group/1 error well digested" do
    assert {:error, message} = Group.get_group("nonValidID")
    assert String.contains?(message, "Elixir.Akiles.Group")
    assert String.contains?(message, "INVALID_REQUEST")
  end

  test "create_group/1 & delete_group/1 works well" do
    assert {:ok, group} = Group.create_group(%{name: "Test Group"})
    assert {:ok, _group} = Group.delete_group(group.id)
  end

  test "edit_group/2 errors well digested" do
    assert {:error, message} = Group.edit_group("IdNotvalid", %{name: "New Name"})
    assert String.contains?(message, "Elixir.Akiles.Group")
    assert String.contains?(message, "INVALID_REQUEST")
  end

  test "find_group/1 works well" do
    group_name = "Test Group #{DateTime.utc_now() |> DateTime.to_unix()}"
    {:ok, group} = Group.create_group(%{name: group_name})
    {:ok, target} = Group.find_group(name: group_name)
    {:ok, _group} = Group.delete_group(group.id)
    assert target.name == group_name
  end
end
