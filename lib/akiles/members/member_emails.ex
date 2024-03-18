defmodule Akiles.MemberEmail do
  @moduledoc """
  Module that defines `Akiles Member Email` entity and the actions available to interact with.
  """

  alias Akiles.Http
  alias Akiles.Utils

  def endpoint(member_id), do: "/members/" <> member_id <> "/emails"

  defstruct [
    :id,
    :organization_id,
    :member_id,
    :email,
    :is_deleted,
    :is_disabled,
    :created_at,
    :metadata
  ]

  @type t() :: %__MODULE__{
          id: term(),
          organization_id: term(),
          member_id: term(),
          email: term(),
          is_deleted: boolean(),
          is_disabled: boolean(),
          created_at: DateTime.t(),
          metadata: map()
        }

  @doc """
  Lists all emails associated to the given MemberId.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberEmail.list_emails("mem_3x9992bcnhjypy4d8pj1")
      {:ok, [
            %Akiles.MemberEmail{
              created_at: "2023-03-28T07:44:34.943041536Z",
              email: "jorge@gmail.com",
              id: "me_3x99c2p9d1sx9kyjlh3h",
              is_deleted: false,
              is_disabled: nil,
              member_id: "mem_3x9992bcnhjypy4d8pj1",
              metadata: %{},
              organization_id: nil
            },
            ...]
  """
  @spec list_emails(term(), term() | nil) :: {:ok, [t()]} | {:ok, []} | {:error, term()}
  def list_emails(member_id, query \\ nil) do
    with {:ok, res} <- Http.list(endpoint(member_id), q: query) do
      res
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Gets the information of a given email.

  Returns `{:ok, data}`.

  ## Examples

      iex>  Akiles.MemberEmail.get_email("mem_3x9992bcnhjypy4d8pj1", "me_3x99c2p9d1sx9kyjlh3h")
      {:ok, %Akiles.MemberEmail{
        created_at: "2023-03-28T07:44:34.943041536Z",
        email: "jorge@gmail.com",
        id: "me_3x99c2p9d1sx9kyjlh3h",
        is_deleted: false,
        is_disabled: nil,
        member_id: "mem_3x9992bcnhjypy4d8pj1",
        metadata: %{},
        organization_id: nil
      }}
  """
  @spec get_email(term(), term()) :: {:ok, t()} | {:error, term()}
  def get_email(member_id, email_id) do
    with {:ok, res} <- Http.get(endpoint(member_id) <> "/" <> email_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Creates the email attribute for the given MemberId.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Member.create_email("mem_3x9992bcnhjypy4d8pj1", %{email: "jorge@gmail.com"})
      {:ok, %Akiles.MemberEmail{
                created_at: "2023-03-28T07:44:34.943041536Z",
                email: "jorge@gmail.com",
                id: "me_3x99c2p9d1sx9kyjlh3h",
                is_deleted: false,
                is_disabled: nil,
                member_id: "mem_3x9992bcnhjypy4d8pj1",
                metadata: %{},
                organization_id: nil
              }}
  """
  @spec create_email(term(), map()) :: {:ok, t()} | {:error, term()}
  def create_email(member_id, data) do
    with {:ok, res} <- Http.post(endpoint(member_id), data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Edits the MemberEmail.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Member.edit_email("mem_3x9992bcnhjypy4d8pj1", "me_3x99c2p9d1sx9kyjlh3h", %{metadata: %{key1: "val1"}})
      {:ok, %Akiles.MemberEmail{
                created_at: "2023-03-28T07:44:34.943041536Z",
                email: "jorge@gmail.com",
                id: "me_3x99c2p9d1sx9kyjlh3h",
                is_deleted: false,
                is_disabled: nil,
                member_id: "mem_3x9992bcnhjypy4d8pj1",
                metadata: %{key1: "val1"},
                organization_id: nil
              }}
  """
  @spec edit_email(term(), term(), map()) :: {:ok, t()} | {:error, term()}
  def edit_email(member_id, email_id, data) do
    with {:ok, res} <- Http.patch(endpoint(member_id) <> "/" <> email_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Deletes the MemberEmail.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Member.delete_email("mem_3x9992bcnhjypy4d8pj1", "me_3x99c2p9d1sx9kyjlh3h"})
      {:ok, %Akiles.MemberEmail{
                created_at: "2023-03-28T07:44:34.943041536Z",
                email: "jorge@gmail.com",
                id: "me_3x99c2p9d1sx9kyjlh3h",
                is_deleted: true,
                is_disabled: nil,
                member_id: "mem_3x9992bcnhjypy4d8pj1",
                metadata: %{key1: "val1"},
                organization_id: nil
              }}
  """
  @spec delete_email(term(), term()) :: {:ok, t()} | {:error, term()}
  def delete_email(member_id, email_id) do
    with {:ok, res} <- Http.delete(endpoint(member_id) <> "/" <> email_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
