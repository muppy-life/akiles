defmodule Akiles.Member do
  @moduledoc """
  Module that defines `Akiles Member` entity and the actions available to interact with.
  """
  
  alias Akiles.Http
  alias Akiles.Utils

  @endpoint "/members"

  defstruct [
    :id, :name, :organization_id, :starts_at, :ends_at, 
    :is_deleted, :is_disabled, :created_at, :metadata
  ]

  @type member() :: %__MODULE__{
    id: String.t(),
    name: String.t(),
    organization_id: String.t(),
    starts_at: DateTime.t(),
    ends_at: DateTime.t(),
    is_deleted: boolean(),
    is_disabled: boolean(),
    created_at: DateTime.t(),
    metadata: Map.t()
  }

  @spec list_members(nil | String.t()) :: {:ok, [member()]} | {:error, String.t()}
  def list_members(email \\ nil) do
    with {:ok, res} <- Http.list(@endpoint, email: email) do
      res 
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> res
    end
  end

  @spec get_member(String.t()) :: {:ok, member()} | {:error, String.t()}
  def get_member(member_id) do
    with {:ok, res} <- Http.get(@endpoint <> "/" <> member_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec create_member(Map.t()) :: {:ok, member()} | {:error, String.t()}
  def create_member(data) do
    with {:ok, res} <- Http.post(@endpoint, data) do
      res
      |> Utils.keys_to_atoms() 
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec edit_member(String.t(), Map.t()) :: {:ok, member()} | {:error, String.t()}
  def edit_member(member_id, data) do
    with {:ok, res} <- Http.patch(@endpoint <> "/" <> member_id, data) do
      res
      |> Utils.keys_to_atoms() 
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec delete_member(String.t()) :: {:ok, member()} | {:error, String.t()}
  def delete_member(member_id) do
    with {:ok, res} <- Http.delete(@endpoint <> "/" <> member_id) do
      res 
      |> Utils.keys_to_atoms() 
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end
end
