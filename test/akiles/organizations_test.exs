defmodule Akiles.OrganizationsTest do
  use ExUnit.Case

  test "get_organization/0 works well" do
    assert {:ok, _data} = Akiles.Organization.get_organization
  end

  test "edit_organization/1 digests errors" do
    assert {:error, message} = Akiles.Organization.edit_organization(%{key1: "val1"})
    assert String.contains?(message, "PERMISSION_DENIED")
    assert String.contains?(message, "Elixir.Akiles.Organization")
  end
end
