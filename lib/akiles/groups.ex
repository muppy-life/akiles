defmodule Akiles.Group do
  @moduledoc """
  Module that defines `Akiles Group` entity and the actions available to interact with.
  """

  alias Akiles.Http
  alias Akiles.Utils

  @endpoint "/member_groups" 

  defstruct [
    :id, :organization_id, :name, 
    :is_deleted, :created_at, :metadata
  ]

  @type group() :: %__MODULE__{
    id: String.t(),
    organization_id: String.t(),
    name: String.t(),
    is_deleted: boolean(),
    created_at: DateTime.t(),
    metadata: Map.t()
  }

  @spec list_groups(String.t() | nil) :: {:ok, [group()]} | {:ok, []} | {:error, String.t()}
  def list_groups(query \\ nil) do
    with {:ok, res} <- Http.list(@endpoint, [q: query]) do
      res 
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> res
    end
  end

  @spec get_group(String.t()) :: {:ok, group()} | {:error, String.t()}
  def get_group(group_id) do
    with {:ok, res} <- Http.get(@endpoint <> "/" <> group_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec create_group(Map.t()) :: {:ok, group()} | {:error, String.t()}
  def create_group(data) do
    with {:ok, res} <- Http.post(@endpoint, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec edit_group(String.t(), Map.t()) :: {:ok, group()} | {:error, String.t()}
  def edit_group(group_id, data) do
    with {:ok, res} <- Http.patch(@endpoint <> "/" <> group_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec delete_group(String.t()) :: {:ok, group()} | {:error, String.t()}
  def delete_group(group_id) do
    with {:ok, res} <- Http.delete(@endpoint <> "/" <> group_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end
end
