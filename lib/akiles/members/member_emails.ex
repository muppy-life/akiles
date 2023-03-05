defmodule Akiles.MemberEmail do
  @moduledoc """
  Module that defines `Akiles Member Email` entity and the actions available to interact with.
  """

  alias Akiles.Http
  alias Akiles.Utils

  def endpoint(member_id), do: "/members/" <> member_id <> "/emails" 

  defstruct [
    :id, :organization_id, :member_id, :email, 
    :is_deleted, :is_disabled, :created_at, :metadata
  ]

  @type member_email() :: %__MODULE__{
    id: String.t(),
    organization_id: String.t(),
    member_id: String.t(),
    email: String.t(),
    is_deleted: boolean(),
    is_disabled: boolean(),
    created_at: DateTime.t(),
    metadata: Map.t()
  }

  @spec list_emails(String.t(), String.t() | nil) :: {:ok, [member_email()]} | {:ok, []} | {:error, String.t()}
  def list_emails(member_id, query \\ nil) do
    with {:ok, res} <- Http.list(endpoint(member_id), q: query) do
      res 
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> res
    end
  end

  @spec get_email(String.t(), String.t()) :: {:ok, member_email()} | {:error, String.t()}
  def get_email(member_id, email_id) do
    with {:ok, res} <- Http.get(endpoint(member_id) <> "/" <> email_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec create_email(String.t(), Map.t()) :: {:ok, member_email()} | {:error, String.t()}
  def create_email(member_id, data) do
    with {:ok, res} <- Http.post(endpoint(member_id), data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec edit_email(String.t(), String.t(), Map.t()) :: {:ok, member_email()} | {:error, String.t()}
  def edit_email(member_id, email_id, data) do
    with {:ok, res} <- Http.patch(endpoint(member_id) <> "/" <> email_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec delete_email(String.t(), String.t()) :: {:ok, member_email()} | {:error, String.t()}
  def delete_email(member_id, email_id) do
    with {:ok, res} <- Http.delete(endpoint(member_id) <> "/" <> email_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end
end
