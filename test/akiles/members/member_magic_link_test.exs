defmodule Akiles.Members.MemberMagicLinkTest do
  use ExUnit.Case

  test "create, edit, reveal and delete" do

    input_user_data = %{name: "Markus"}
    link_edit = %{
      "metadata": %{
        "key1": "value1",
        "key2": "value2"
      }
    }
    {:ok, created_user} = Akiles.Member.create_member(input_user_data)
    {:ok, created_link} = Akiles.MemberMagicLink.create_magic_link(created_user.id, %{})
    {:ok, reveal_created} = Akiles.MemberMagicLink.reveal_magic_link(created_user.id, created_link.id)

    {:ok, edited_link} = Akiles.MemberMagicLink.edit_magic_link(created_user.id, created_link.id, link_edit)

    {:ok, deleted_link} = Akiles.MemberMagicLink.delete_magic_link(created_user.id, created_link.id)

    {:ok, _deleted_user} = Akiles.Member.delete_member(created_user.id)

    assert %Akiles.MemberMagicLink{} = created_link
    assert %Akiles.MemberMagicLink{} = edited_link
    assert %Akiles.MemberMagicLink{} = deleted_link

    assert created_link.member_id == created_user.id
    assert created_link.member_id == deleted_link.member_id

    assert edited_link.metadata == link_edit.metadata
  end

  test "list & get" do
    input_user_data = %{name: "John Doe"}
    {:ok, created_user} = Akiles.Member.create_member(input_user_data)
    {:ok, created_link} = Akiles.MemberMagicLink.create_magic_link(created_user.id, %{})
    {:ok, [link | _rest]} = Akiles.MemberMagicLink.list_magic_links(created_user.id)
    {:ok, get_link} = Akiles.MemberMagicLink.get_magic_link(created_user.id, created_link.id)
    {:ok, deleted_link} = Akiles.MemberMagicLink.delete_magic_link(created_user.id, created_link.id)
    {:ok, _deleted_user} = Akiles.Member.delete_member(created_user.id)

    assert link.id == created_link.id
    assert get_link == link
  end

end
