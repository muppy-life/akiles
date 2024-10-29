defmodule Akiles.Gadget do
  @moduledoc """
  Module that defines `Akiles Gadget` entity and the actions available to interact with.
  """

  alias Akiles.Http
  alias Akiles.Utils

  @endpoint "/gadgets"

  defstruct [
    :id,
    :organization_id,
    :site_id,
    :device_id,
    :name,
    :position,
    :actions,
    :is_deleted,
    :created_at,
    :metadata
  ]

  @type t() :: %__MODULE__{
          id: term(),
          organization_id: term(),
          site_id: term(),
          device_id: term(),
          name: term(),
          actions: [gadget_action()],
          is_deleted: [boolean()],
          created_at: DateTime.t(),
          metadata: map()
        }

  @type gadget_action() :: %{
          id: term(),
          name: term()
        }

  @doc """
  Lists all gadgets.

  returns {:ok, data}
  ## Examples
      iex> Akiles.Gadget.list_gadgets()
      {:ok, [
        %Akiles.Gadget{
          id: "gad_3ymsqc2ja8zcls67vhy1",
          organization_id: "org_3uzx1fn9pl87fcyv11c1", 
          site_id: "site_3ym2ur1zvr1x9t2185hh",
          device_id: "dev_3ymsqc2ja38hcxaqldk1",
          name: "Puerta piso",
          position: nil,
          actions: [
            %{
              :id => "open",
              :index => 0, 
              :name => "open",
              :help => "push_door",
              "i18n_name" => "open"
            }
          ],
          is_deleted: false,
          created_at: "2024-01-12T13:11:37.799991296Z",
          metadata: %{}
        }
      ]}

  """
  def list_gadgets do
    with {:ok, res} <- Http.list(@endpoint) do
      res
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Get gadget data from Id.

  returns {:ok, data}
  ## Examples

      iex> Akiles.Gadget.get_gadget("gad_3merk33gt1hnl6pvbu71")
      {:ok, %Akiles.Gadget{
          id: "gad_3ymsqc2ja8zcls67vhy1",
          organization_id: "org_3uzx1fn9pl87fcyv11c1", 
          site_id: "site_3ym2ur1zvr1x9t2185hh",
          device_id: "dev_3ymsqc2ja38hcxaqldk1",
          name: "Puerta piso",
          position: nil,
          actions: [
            %{
              :id => "open",
              :index => 0, 
              :name => "open",
              :help => "push_door",
              "i18n_name" => "open"
            }
          ],
          is_deleted: false,
          created_at: "2024-01-12T13:11:37.799991296Z",
          metadata: %{}
        }
        }
  """
  def get_gadget(gadget_id) do
    with {:ok, res} <- Http.get(@endpoint <> "/" <> gadget_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec find_gadget([{term(), term()}]) :: {:ok, t()} | {:error, term()}
  def find_gadget(param) do
    with {:ok, res} <- Http.search(@endpoint, param, nil) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Edits the gadget data -> Adds key value pairs to the metadata.

  Returns `{:ok, data}`.

  ## Examples
      iex> Akiles.Gadget.edit_gadget("gad_3merk33gt1hnl6pvbu71", {"metadata": {
                                                                        "key1": "value1",
                                                                        "key2": "value2"}
                                                                  })
      {:ok, %Akiles.Gadget{
          id: "gad_3ymsqc2ja8zcls67vhy1",
          organization_id: "org_3uzx1fn9pl87fcyv11c1", 
          site_id: "site_3ym2ur1zvr1x9t2185hh",
          device_id: "dev_3ymsqc2ja38hcxaqldk1",
          name: "Puerta piso",
          position: nil,
          actions: [
            %{
              :id => "open",
              :index => 0, 
              :name => "open",
              :help => "push_door",
              "i18n_name" => "open"
            }
          ],
          is_deleted: false,
          created_at: "2024-01-12T13:11:37.799991296Z",
          metadata: %{}
        }
      }
  """
  def edit_gadget(gadget_id, data) do
    with {:ok, res} <- Http.patch(@endpoint <> "/" <> gadget_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Performs an action on a gadget.

  Returns :ok

  ## Example
  iex> Akiles.Gadget.do_gadget_action("gad_3merk33gt1hnl6pvbu71", "open")
  :ok
  """
  def do_gadget_action(gadget_id, action_id) do
    url = @endpoint <> "/" <> gadget_id <> "/actions" <> "/" <> action_id

    with {:ok, _res} <- Http.post(url, %{}) do
      :ok
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
