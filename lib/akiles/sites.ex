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

  @doc """
  Lists all sites.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Site.list_sites
      {:ok, {
            "data": [
              {
                "id": "site_3merk33gt21kym11een1",
                "name": "string",
                "organization_id": "org_3merk33gt1v9ypgfzrp1",
                "geo": {
                  "location": {
                    "lat": 41.290485,
                    "lng": 2.1829076
                  },
                  "radius": 100
                },
                "map": {
                  "location": {
                    "lat": 41.290485,
                    "lng": 2.1829076
                  },
                  "place_id": "string",
                  "address": "string",
                  "image_url": "string"
                },
                "phone": "string",
                "email": "string",
                "info": "string",
                "timezone": "Europe/Madrid",
                "is_deleted": false,
                "created_at": "2018-03-13T16:56:51.766836837Z",
                "metadata": {
                  "key1": "value1",
                  "key2": "value2"
                }
              }
            ],
            "has_next": true,
            "cursor_next": "i9vmCnOgONT2AjUMCn1K1N5cJg=="
          }
  """
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


  @spec find_site([{term(), term()}]) :: {:ok, t()} | {:error, term()}
  def find_site(param) do
    with {:ok, res} <- Http.search(@endpoint, param, nil) do
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
