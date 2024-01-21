defmodule AkilesTests.MemberEmail do
  use ExUnit.Case
  alias Akiles.Member
  alias Akiles.MemberEmail

  test "create & delete member email" do
    input_user_data = %{name: "John Doe"}
    input_email_data = %{email: "john_doe@muppy.com"}

    {:ok, created_user} = Member.create_member(input_user_data)
    {:ok, created_email} = MemberEmail.create_email(created_user.id, input_email_data)
    {:ok, deleted_email} = MemberEmail.delete_email(created_user.id, created_email.id)
    {:ok, _deleted_user} = Member.delete_member(created_user.id)

    assert %MemberEmail{} = created_email
    assert %MemberEmail{} = deleted_email
    assert input_email_data.email == created_email.email
    assert input_email_data.email == deleted_email.email
    assert created_email.id == deleted_email.id
  end

  test "list & get" do
    input_user_data = %{name: "John Doe"}
    input_email_data = %{email: "john_doe@muppy.com"}
    input_email_data2 = %{email: "johnny@muppy.com"}

    {:ok, created_member} = Member.create_member(input_user_data)
    {:ok, _created_email} = MemberEmail.create_email(created_member.id, input_email_data)
    {:ok, _created_email2} = MemberEmail.create_email(created_member.id, input_email_data2)

    {:ok, [email1, email2]} = MemberEmail.list_emails(created_member.id)
    {:ok, get_email} = MemberEmail.get_email(created_member.id, email1.id)
    {:ok, _deleted_email} = MemberEmail.delete_email(created_member.id, email1.id)
    {:ok, _deleted_email} = MemberEmail.delete_email(created_member.id, email2.id)
    {:ok, _deleted_user} = Member.delete_member(created_member.id)

    assert [email2.email, email1.email] == [input_email_data.email, input_email_data2.email]
    assert email1.member_id == email2.member_id
    assert get_email == email1
  end

  test "edit member email" do
    input_user_data = %{name: "John Doe"}
    input_email_data = %{email: "john_doe@muppy.com"}
    edit_data = %{metadata: %{test: "cansino"}}
    error_data = %{other_field: "whatever"}

    {:ok, created_user} = Member.create_member(input_user_data)
    {:ok, created_email} = MemberEmail.create_email(created_user.id, input_email_data)
    {:ok, edited_email} = MemberEmail.edit_email(created_user.id, created_email.id, edit_data)
    {:ok, _deleted_user} = Member.delete_member(created_user.id)

    assert %MemberEmail{} = edited_email
    assert edit_data.metadata == edited_email.metadata
    assert {:error, _msg} = MemberEmail.edit_email(created_user.id, created_email.id, error_data)
  end

  test "error is raised if id does not exist" do
    assert {:error, _msg} = MemberEmail.list_emails("InvalidId")
    assert {:error, _msg} = MemberEmail.get_email("InvalidId", "InvalidId")
    assert {:error, _msg} = MemberEmail.create_email("InvalidId", %{})
    assert {:error, _msg} = MemberEmail.delete_email("InvalidId", "InvalidId")
  end
end
