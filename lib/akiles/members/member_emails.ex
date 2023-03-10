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
