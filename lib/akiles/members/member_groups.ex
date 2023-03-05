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

  @type group_assoc() :: %__MODULE__{
    id: String.t(),
    organization_id: String.t(),
    member_id: String.t(),
    member_group_id: String.t(),
    starts_at: DateTime.t(),
    ends_at: DateTime.t(),
    is_deleted: boolean(),
    is_disabled: boolean(),
    created_at: DateTime.t(),
    metadata: Map.t()
  }

  @spec list_group_assoc(String.t()) :: {:ok, [group_assoc()]} | {:ok, []} | {:error, String.t()}
  def list_group_assoc(member_id) do
    with {:ok, res} <- Http.list(endpoint(member_id)) do
      res 
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> res
    end
  end

  @spec get_group_assoc(String.t(), String.t()) :: {:ok, group_assoc()} | {:error, String.t()}
  def get_group_assoc(member_id, group_assoc_id) do
    with {:ok, res} <- Http.get(endpoint(member_id) <> "/" <> group_assoc_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec create_group_assoc(String.t(), Map.t()) :: {:ok, group_assoc()} | {:error, String.t()}
  def create_group_assoc(member_id, data) do
    with {:ok, res} <- Http.post(endpoint(member_id), data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec edit_group_assoc(String.t(), String.t(), Map.t()) :: {:ok, group_assoc()} | {:error, String.t()}
  def edit_group_assoc(member_id, group_assoc_id, data) do
    with {:ok, res} <- Http.patch(endpoint(member_id) <> "/" <> group_assoc_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec delete_group_assoc(String.t(), String.t()) :: {:ok, group_assoc()} | {:error, String.t()}
  def delete_group_assoc(member_id, group_assoc_id) do
    with {:ok, res} <- Http.delete(endpoint(member_id) <> "/" <> group_assoc_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end
end
