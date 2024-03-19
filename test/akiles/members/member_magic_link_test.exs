defmodule Members.MemberMagicLinkTest do
  use ExUnit.Case
  alias Akiles.MemberMagicLink
  alias Akiles.Member

  test "create, edit, reveal and delete" do
    input_user_data = %{name: "Markus"}

    link_edit = %{
      metadata: %{
        key1: "value1",
        key2: "value2"
      }
    }

    {:ok, created_user} = Member.create_member(input_user_data)
    {:ok, created_link} = MemberMagicLink.create_magic_link(created_user.id, %{})
    {:ok, _reveal_created} = MemberMagicLink.reveal_magic_link(created_user.id, created_link.id)

    {:ok, edited_link} =
      MemberMagicLink.edit_magic_link(created_user.id, created_link.id, link_edit)

    {:ok, deleted_link} = MemberMagicLink.delete_magic_link(created_user.id, created_link.id)
    {:ok, _deleted_user} = Member.delete_member(created_user.id)

    assert %MemberMagicLink{} = created_link
    assert %MemberMagicLink{} = edited_link
    assert %MemberMagicLink{} = deleted_link
    assert created_link.member_id == created_user.id
    assert created_link.member_id == deleted_link.member_id
    assert edited_link.metadata == link_edit.metadata
  end

  test "list & get" do
    input_user_data = %{name: "John Doe"}
    {:ok, created_user} = Member.create_member(input_user_data)
    {:ok, created_link} = MemberMagicLink.create_magic_link(created_user.id, %{})
    {:ok, [link | _rest]} = MemberMagicLink.list_magic_links(created_user.id)
    {:ok, get_link} = MemberMagicLink.get_magic_link(created_user.id, created_link.id)
    {:ok, _deleted_link} = MemberMagicLink.delete_magic_link(created_user.id, created_link.id)
    {:ok, _deleted_user} = Member.delete_member(created_user.id)

    assert link.id == created_link.id
    assert get_link == link
  end
end
