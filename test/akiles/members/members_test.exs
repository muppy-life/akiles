defmodule AkilesTests.Member do
  use ExUnit.Case
  alias Akiles.Member

  test "create & delete member" do
    input_data = %{name: "John Doe"}
    {:ok, created_user} = Member.create_member(input_data)
    {:ok, deleted_user} = Member.delete_member(created_user.id)

    assert %Member{} = created_user
    assert %Member{} = deleted_user
    assert input_data.name == created_user.name
    assert input_data.name == deleted_user.name
    assert created_user.id == deleted_user.id
  end

  test "edit member" do
    input_data = %{name: "John Doe"}
    edit_data = %{name: "Homer Simpson"}
    {:ok, created_user} = Member.create_member(input_data)
    {:ok, edited_user} = Member.edit_member(created_user.id, edit_data)
    {:ok, _deleted_user} = Member.delete_member(edited_user.id)

    assert %Member{} = edited_user
    assert edit_data.name == edited_user.name
    assert created_user.id == edited_user.id
  end

  test "list_members/0 and get_member work well" do
    assert {:ok, [data | _rest]} = Member.list_members
    assert {:ok, data} == Member.get_member(data.id)
  end

  test "invalid id errors are well digested" do
    assert {:error, _msg} = Member.get_member("InvalidId")
    assert {:error, _msg} = Member.edit_member("InvalidId", %{})
    assert {:error, _msg} = Member.delete_member("InvalidId")
  end

  test "find_member/1 works well" do
    name = "Test Member #{DateTime.utc_now() |> DateTime.to_unix()}"
    {:ok, member} = Member.create_member(%{name: name})
    {:ok, target} = Member.find_member(name: name)
    {:ok, _member} = Member.delete_member(member.id)
    assert target.name == name
  end
end
