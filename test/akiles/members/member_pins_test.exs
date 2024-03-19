defmodule Members.MemberPinsTest do
  use ExUnit.Case
  alias Akiles.Member
  alias Akiles.MemberPin

  test "create & edit & delete & reveal" do
    input_user_data = %{name: "Markus"}

    pin_data = %{
      length: 10,
      pin: "1234567890",
      metadata: %{}
    }

    pin_edit = %{
      metadata: %{
        key1: "value1",
        key2: "value2"
      }
    }

    {:ok, created_user} = Member.create_member(input_user_data)
    {:ok, created_pin} = MemberPin.create_pin(created_user.id, pin_data)
    {:ok, reveal_created} = MemberPin.reveal_pin(created_user.id, created_pin.id)

    {:ok, edited_pin} = MemberPin.edit_pin(created_user.id, created_pin.id, pin_edit)
    {:ok, reveal_edited} = MemberPin.reveal_pin(created_user.id, edited_pin.id)

    {:ok, deleted_pin} = MemberPin.delete_pin(created_user.id, created_pin.id)

    {:ok, _deleted_user} = Member.delete_member(created_user.id)

    assert %MemberPin{} = created_pin
    assert %MemberPin{} = edited_pin
    assert %MemberPin{} = deleted_pin

    assert created_pin.member_id == created_user.id
    assert created_pin.member_id == deleted_pin.member_id

    assert edited_pin.metadata == pin_edit.metadata
    assert reveal_created.pin == reveal_edited.pin
  end

  test "list & get" do
    input_user_data = %{name: "John Doe"}

    pin_data = %{
      length: 10,
      pin: "1234567890",
      metadata: %{}
    }

    {:ok, created_user} = Member.create_member(input_user_data)
    {:ok, created_pin} = MemberPin.create_pin(created_user.id, pin_data)
    {:ok, [pin | _rest]} = MemberPin.list_pins(created_user.id)
    {:ok, get_pin} = MemberPin.get_pin(created_user.id, created_pin.id)
    {:ok, _deleted_pin} = MemberPin.delete_pin(created_user.id, created_pin.id)
    {:ok, _deleted_user} = Member.delete_member(created_user.id)

    assert pin.id == created_pin.id
    assert get_pin == pin
  end

  test "Error is raised if invalid id" do
    assert {:error, _msg} = MemberPin.list_pins("InvalidId")
    assert {:error, _msg} = MemberPin.get_pin("InvalidId", "InvalidId")
    assert {:error, _msg} = MemberPin.create_pin("InvalidId", %{})
    assert {:error, _msg} = MemberPin.edit_pin("InvalidId", "InvalidId", %{})
    assert {:error, _msg} = MemberPin.delete_pin("InvalidId", "InvalidId")
    assert {:error, _msg} = MemberPin.reveal_pin("InvalidId", "InvalidId")
  end
end
