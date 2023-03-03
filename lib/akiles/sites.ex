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
    location: %{lat: String.t(), lng: String.t()},
    radius: Integer.t()
  }

  @type site_map() :: %{
    location: %{lat: String.t(), lng: String.t()},
    place_id: String.t(),
    address: String.t(),
    image_url: String.t()
  }

  @type site() :: %__MODULE__{
    id: String.t(),
    name: String.t(),
    organization_id: String.t(),
    geo: site_geo(),
    map: site_map(),
    phone: String.t(),
    email: String.t(),
    info: String.t(),
    timezone: String.t(),
    is_deleted: boolean(),
    is_disabled: boolean(),
    created_at: DateTime.t(),
    metadata: Map.t()
  }

  @spec list_sites() :: {:ok, [site()]} | {:error, String.t()}
  def list_sites() do
    with {:ok, res} <- Http.list(@endpoint) do
      res 
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> res
    end
  end

  @spec get_site(String.t()) :: {:ok, site()} | {:error, String.t()}
  def get_site(site_id) do
    with {:ok, res} <- Http.get(@endpoint <> "/" <> site_id) do
      res 
      |> Utils.keys_to_atoms() 
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec edit_site(String.t(), Map.t()) :: {:ok, site()} | {:error, String.t()}
  def edit_site(site_id, data) do
    with {:ok, res} <- Http.patch(@endpoint <> "/" <> site_id, %{metadata: data}) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end
end
