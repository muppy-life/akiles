defmodule Akiles.Members.MemberGroupAssociationsTest do
  use ExUnit.Case

  test "create & edit & delete group association" do
    input_user_data = %{name: "John Doe"}
    # There is only 1 member group in Test API and it is not posible
    # to create a group through the API
    input_group_id = "mg_3x94q5zq9r6vc143qslh"
    input_assoc_data = %{
      "member_group_id": input_group_id,
      "starts_at": "2023-03-13T16:56:51.766836837Z",
      "ends_at": "2023-03-13T16:56:51.766836837Z",
      "metadata": %{}
    }
    input_edit_data = %{
      "starts_at": "2023-03-13T16:56:51.766836837Z",
      "ends_at": "2023-03-13T16:56:51.766836837Z",
      "metadata": %{
        "key1": "value1",
        "key2": "value2"
      }
    }

    {:ok, created_user} = Akiles.Member.create_member(input_user_data)
    {:ok, created_assoc} = Akiles.MemberGroupAssociation.create_group_assoc(created_user.id, input_assoc_data)
    {:ok, edited_assoc} = Akiles.MemberGroupAssociation.edit_group_assoc(created_user.id, created_assoc.id, input_edit_data)
    {:ok, deleted_assoc} = Akiles.MemberGroupAssociation.delete_group_assoc(created_user.id, created_assoc.id)
    {:ok, _deleted_user} = Akiles.Member.delete_member(created_user.id)

    assert %Akiles.MemberGroupAssociation{} = created_assoc
    assert created_assoc.member_id == created_user.id
    assert created_assoc.member_group_id == input_group_id
    assert edited_assoc.metadata == input_edit_data.metadata
    assert deleted_assoc.id == created_assoc.id
  end

  test "list and get" do
    input_user_data = %{name: "John Doe"}
    # There is only 1 member group in Test API and it is not posible
    # to create a group through the API
    input_group_id = "mg_3x94q5zq9r6vc143qslh"
    input_assoc_data = %{
      "member_group_id": input_group_id,
      "starts_at": "2023-03-13T16:56:51.766836837Z",
      "ends_at": "2023-03-13T16:56:51.766836837Z",
      "metadata": %{}
    }

    {:ok, created_user} = Akiles.Member.create_member(input_user_data)
    {:ok, created_assoc} = Akiles.MemberGroupAssociation.create_group_assoc(created_user.id, input_assoc_data)

    assert {:ok, [assoc | _rest]} = Akiles.MemberGroupAssociation.list_group_assoc(created_user.id)
    assert {:ok, assoc} == Akiles.MemberGroupAssociation.get_group_assoc(created_user.id, created_assoc.id)

    {:ok, _deleted_assoc} = Akiles.MemberGroupAssociation.delete_group_assoc(created_user.id, created_assoc.id)
    {:ok, _deleted_user} = Akiles.Member.delete_member(created_user.id)
  end

  test "Error if invalid id" do
    assert {:error, _msg} = Akiles.MemberGroupAssociation.list_group_assoc("InvalidId")
    assert {:error, _msg} = Akiles.MemberGroupAssociation.get_group_assoc("InvalidId", "InvalidId")
    assert {:error, _msg} = Akiles.MemberGroupAssociation.create_group_assoc("InvalidId", %{})
    assert {:error, _msg} = Akiles.MemberGroupAssociation.edit_group_assoc("InvalidId", "InvalidId", %{})
    assert {:error, _msg} = Akiles.MemberGroupAssociation.delete_group_assoc("InvalidId", "InvalidId")
  end
end
