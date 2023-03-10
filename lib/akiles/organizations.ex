defmodule Akiles.Organization do
  @moduledoc """
  Module that defines `Akiles Organization` entity and the actions available to interact with.
  """
  
  alias Akiles.Http
  alias Akiles.Utils
  
  @endpoint "/organization"

  defstruct [:id, :name, :is_deleted, :is_disabled, :created_at, :metadata]

  @type t() :: %__MODULE__{
    id: String.t(),
    name: String.t(),
    is_deleted: boolean(),
    is_disabled: boolean(),
    created_at: DateTime.t(),
    metadata: Map.t()
  }

  @spec get_organization() :: t()
  def get_organization() do
    with {:ok, res} <- Http.get(@endpoint) do
      res |> Utils.keys_to_atoms() |> then(&struct!(%__MODULE__{}, &1))
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec edit_organization(Map.t()) :: t()
  def edit_organization(data) do
    with {:ok, res} <- Http.patch(@endpoint, %{metadata: data}) do
      res |> Utils.keys_to_atoms() |> then(&struct!(%__MODULE__{}, &1))
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
