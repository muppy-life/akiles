defmodule Akiles.MemberGroupAssociation do
  @moduledoc """
  Module that defines `Akiles Member Group Association` entity and the actions available to interact with.
  """

  alias Akiles.Http
  alias Akiles.Utils

  def endpoint(member_id), do: "/members/" <> member_id <> "/group_associations" 

  defstruct [
    :id, :organization_id, :member_id, :member_group_id, :starts_at, :ends_at,
    :is_deleted, :is_disabled, :created_at, :metadata
  ]

  @type t() :: %__MODULE__{
    id: term(),
    organization_id: term(),
    member_id: term(),
    member_group_id: term(),
    starts_at: DateTime.t(),
    ends_at: DateTime.t(),
    is_deleted: boolean(),
    is_disabled: boolean(),
    created_at: DateTime.t(),
    metadata: map()
  }

  @spec list_group_assoc(term()) :: {:ok, [t()]} | {:ok, []} | {:error, term()}
  def list_group_assoc(member_id) do
    with {:ok, res} <- Http.list(endpoint(member_id)) do
      res 
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec get_group_assoc(term(), term()) :: {:ok, t()} | {:error, term()}
  def get_group_assoc(member_id, group_assoc_id) do
    with {:ok, res} <- Http.get(endpoint(member_id) <> "/" <> group_assoc_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec create_group_assoc(term(), map()) :: {:ok, t()} | {:error, term()}
  def create_group_assoc(member_id, data) do
    with {:ok, res} <- Http.post(endpoint(member_id), data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec edit_group_assoc(term(), term(), map()) :: {:ok, t()} | {:error, term()}
  def edit_group_assoc(member_id, group_assoc_id, data) do
    with {:ok, res} <- Http.patch(endpoint(member_id) <> "/" <> group_assoc_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec delete_group_assoc(term(), term()) :: {:ok, t()} | {:error, term()}
  def delete_group_assoc(member_id, group_assoc_id) do
    with {:ok, res} <- Http.delete(endpoint(member_id) <> "/" <> group_assoc_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
