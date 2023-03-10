defmodule Akiles.Site do
  @moduledoc """
  Module that defines `Akiles Site` entity and the actions available to interact with.
  """
  
  alias Akiles.Http
  alias Akiles.Utils

  @endpoint "/sites"

  defstruct [
    :id, :name, :organization_id, :geo, :map, :phone, :email, :info, :timezone, 
    :is_deleted, :is_disabled, :created_at, :metadata
  ]

  @type site_geo() :: %{
    location: %{lat: term(), lng: term()},
    radius: Integer.t()
  }

  @type site_map() :: %{
    location: %{lat: term(), lng: term()},
    place_id: term(),
    address: term(),
    image_url: term()
  }

  @type t() :: %__MODULE__{
    id: term(),
    name: term(),
    organization_id: term(),
    geo: site_geo(),
    map: site_map(),
    phone: term(),
    email: term(),
    info: term(),
    timezone: term(),
    is_deleted: boolean(),
    is_disabled: boolean(),
    created_at: DateTime.t(),
    metadata: map()
  }

  @spec list_sites() :: {:ok, [t()]} | {:error, term()}
  def list_sites() do
    with {:ok, res} <- Http.list(@endpoint) do
      res 
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec get_site(term()) :: {:ok, t()} | {:error, term()}
  def get_site(site_id) do
    with {:ok, res} <- Http.get(@endpoint <> "/" <> site_id) do
      res 
      |> Utils.keys_to_atoms() 
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec edit_site(term(), map()) :: {:ok, t()} | {:error, term()}
  def edit_site(site_id, data) do
    with {:ok, res} <- Http.patch(@endpoint <> "/" <> site_id, %{metadata: data}) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
