defmodule Members.MemberGroupAssociationsTest do
  use ExUnit.Case
  alias Akiles.MemberGroupAssociation
  alias Akiles.Member
  alias Akiles.Group

  test "create & edit & delete group association" do
    input_user_data = %{name: "John Doe"}

    input_edit_data = %{
      starts_at: "2023-03-13T16:56:51.766836837Z",
      ends_at: "2023-03-13T16:56:51.766836837Z",
      metadata: %{
        key1: "value1",
        key2: "value2"
      }
    }

    {:ok, group} = Group.create_group(%{name: "Test Group"})

    input_assoc_data = %{
      member_group_id: group.id,
      starts_at: "2023-03-13T16:56:51.766836837Z",
      ends_at: "2023-03-13T16:56:51.766836837Z",
      metadata: %{}
    }

    {:ok, created_user} = Member.create_member(input_user_data)
    {:ok, created_assoc} = MemberGroupAssociation.create_group_assoc(created_user.id, input_assoc_data)
    {:ok, edited_assoc} = MemberGroupAssociation.edit_group_assoc(created_user.id, created_assoc.id, input_edit_data)
    {:ok, deleted_assoc} = MemberGroupAssociation.delete_group_assoc(created_user.id, created_assoc.id)
    {:ok, _deleted_user} = Member.delete_member(created_user.id)
    {:ok, _group} = Group.delete_group(group.id)

    assert %MemberGroupAssociation{} = created_assoc
    assert created_assoc.member_id == created_user.id
    assert created_assoc.member_group_id == group.id
    assert edited_assoc.metadata == input_edit_data.metadata
    assert deleted_assoc.id == created_assoc.id
  end

  test "list and get" do
    input_user_data = %{name: "John Doe"}
    input_group_id = "mg_3x94q5zq9r6vc143qslh"
    input_assoc_data = %{
      member_group_id: input_group_id,
      starts_at: "2023-03-13T16:56:51.766836837Z",
      ends_at: "2023-03-13T16:56:51.766836837Z",
      metadata: %{}
    }

    {:ok, created_user} = Member.create_member(input_user_data)
    {:ok, created_assoc} = MemberGroupAssociation.create_group_assoc(created_user.id, input_assoc_data)

    assert {:ok, [assoc | _rest]} = MemberGroupAssociation.list_group_assoc(created_user.id)
    assert {:ok, assoc} == MemberGroupAssociation.get_group_assoc(created_user.id, created_assoc.id)

    {:ok, _deleted_assoc} = MemberGroupAssociation.delete_group_assoc(created_user.id, created_assoc.id)
    {:ok, _deleted_user} = Member.delete_member(created_user.id)
  end

  test "Error if invalid id" do
    assert {:error, _msg} = MemberGroupAssociation.list_group_assoc("InvalidId")
    assert {:error, _msg} = MemberGroupAssociation.get_group_assoc("InvalidId", "InvalidId")
    assert {:error, _msg} = MemberGroupAssociation.create_group_assoc("InvalidId", %{})
    assert {:error, _msg} = MemberGroupAssociation.edit_group_assoc("InvalidId", "InvalidId", %{})
    assert {:error, _msg} = MemberGroupAssociation.delete_group_assoc("InvalidId", "InvalidId")
  end
end
