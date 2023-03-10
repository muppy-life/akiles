defmodule AkilesTests.MemberEmail do
  use ExUnit.Case

  test "create & delete member email" do
    input_user_data = %{name: "John Doe"}
    input_email_data = %{email: "john_doe@muppy.com"}

    {:ok, created_user} = Akiles.Member.create_member(input_user_data)
    {:ok, created_email} = Akiles.MemberEmail.create_email(created_user.id, input_email_data)
    {:ok, deleted_email} = Akiles.MemberEmail.delete_email(created_user.id, created_email.id)
    {:ok, _deleted_user} = Akiles.Member.delete_member(created_user.id)

    assert %Akiles.MemberEmail{} = created_email
    assert %Akiles.MemberEmail{} = deleted_email
    assert input_email_data.email == created_email.email
    assert input_email_data.email == deleted_email.email
    assert created_email.id == deleted_email.id
  end

  test "edit member email" do
    input_user_data = %{name: "John Doe"}
    input_email_data = %{email: "john_doe@muppy.com"}
    edit_data = %{metadata: %{test: "cansino"}}
    error_data = %{other_field: "whatever"}

    {:ok, created_user} = Akiles.Member.create_member(input_user_data)
    {:ok, created_email} = Akiles.MemberEmail.create_email(created_user.id, input_email_data)
    {:ok, edited_email} = Akiles.MemberEmail.edit_email(created_user.id, created_email.id, edit_data)
    {:ok, _deleted_user} = Akiles.Member.delete_member(created_user.id)

    assert %Akiles.MemberEmail{} = edited_email
    assert edit_data.metadata == edited_email.metadata
    assert {:error, _msg} = Akiles.MemberEmail.edit_email(created_user.id, created_email.id, error_data)
  end
end
