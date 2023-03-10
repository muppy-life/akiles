defmodule AkilesTests.Member do
  use ExUnit.Case

  test "create & delete member" do
    input_data = %{name: "John Doe"}
    {:ok, created_user} = Akiles.Member.create_member(input_data)
    {:ok, deleted_user} = Akiles.Member.delete_member(created_user.id)

    assert %Akiles.Member{} = created_user
    assert %Akiles.Member{} = deleted_user
    assert input_data.name == created_user.name
    assert input_data.name == deleted_user.name
    assert created_user.id == deleted_user.id
  end

  test "edit member" do
    input_data = %{name: "John Doe"}
    edit_data = %{name: "Homer Simpson"}
    {:ok, created_user} = Akiles.Member.create_member(input_data)
    {:ok, edited_user} = Akiles.Member.edit_member(created_user.id, edit_data)
    {:ok, _deleted_user} = Akiles.Member.delete_member(edited_user.id)

    assert %Akiles.Member{} = edited_user
    assert edit_data.name == edited_user.name
    assert created_user.id == edited_user.id
  end
end
