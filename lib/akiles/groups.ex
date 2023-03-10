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

  @type t() :: %__MODULE__{
    id: term(),
    organization_id: term(),
    name: term(),
    is_deleted: boolean(),
    created_at: DateTime.t(),
    metadata: map()
  }

  @spec list_groups(term() | nil) :: {:ok, [t()]} | {:ok, []} | {:error, term()}
  def list_groups(query \\ nil) do
    with {:ok, res} <- Http.list(@endpoint, [q: query]) do
      res 
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec get_group(term()) :: {:ok, t()} | {:error, term()}
  def get_group(group_id) do
    with {:ok, res} <- Http.get(@endpoint <> "/" <> group_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec create_group(map()) :: {:ok, t()} | {:error, term()}
  def create_group(data) do
    with {:ok, res} <- Http.post(@endpoint, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec edit_group(term(), map()) :: {:ok, t()} | {:error, term()}
  def edit_group(group_id, data) do
    with {:ok, res} <- Http.patch(@endpoint <> "/" <> group_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec delete_group(term()) :: {:ok, t()} | {:error, term()}
  def delete_group(group_id) do
    with {:ok, res} <- Http.delete(@endpoint <> "/" <> group_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
