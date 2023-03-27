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

  @type t() :: %__MODULE__{
    id: term(),
    name: term(),
    organization_id: term(),
    starts_at: DateTime.t(),
    ends_at: DateTime.t(),
    is_deleted: boolean(),
    is_disabled: boolean(),
    created_at: DateTime.t(),
    metadata: map()
  }

  @spec list_members(term() | nil) :: {:ok, [t()]} | {:error, term()}
  def list_members(email \\ nil) do
    with {:ok, res} <- Http.list(@endpoint, email: email) do
      res 
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec get_member(term()) :: {:ok, t()} | {:error, term()}
  def get_member(member_id) do
    with {:ok, res} <- Http.get(@endpoint <> "/" <> member_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec create_member(map()) :: {:ok, t()} | {:error, term()}
  def create_member(data) do
    with {:ok, res} <- Http.post(@endpoint, data) do
      res
      |> Utils.keys_to_atoms() 
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec edit_member(term(), map()) :: {:ok, t()} | {:error, term()}
  def edit_member(member_id, data) do
    with {:ok, res} <- Http.patch(@endpoint <> "/" <> member_id, data) do
      res
      |> Utils.keys_to_atoms() 
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec delete_member(term()) :: {:ok, t()} | {:error, term()}
  def delete_member(member_id) do
    with {:ok, res} <- Http.delete(@endpoint <> "/" <> member_id) do
      res 
      |> Utils.keys_to_atoms() 
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
