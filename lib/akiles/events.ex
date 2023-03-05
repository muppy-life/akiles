defmodule Akiles.Event do
  @moduledoc """
  Module that defines `Akiles Event` entity and the actions available to interact with.
  """

  alias Akiles.Http
  alias Akiles.Utils

  @endpoint "/events" 

  defstruct [
    :id, :organization_id, :subject, 
    :verb, :object, :created_at
  ]

  @type event_subject() :: %{
    type: String.t(),
    member_id: String.t(),
    user_id: String.t(),
    user_session_id: String.t(),
    api_key_id: String.t(),
    admin_id: String.t()
  }

  @type event_verb() :: :create | :edit | :delete | :use

  @type event_object() :: %{
    type: String.t(), 
    admin_id: String.t(), 
    api_key_id: String.t(),
    device_id: String.t(),
    gadget_id: String.t(),
    link_id: String.t(),
    member_id: String.t(),
    member_event_id: String.t(),
    member_invitation_id: String.t(),
    site_id: String.t(),
    gadget_action_id: String.t()
  }

  @type event() :: %__MODULE__{
    id: String.t(),
    organization_id: String.t(),
    subject: event_subject(),
    verb: event_verb(),
    object: event_object(),
    created_at: DateTime.t()
  }

  @spec list_events() :: {:ok, [event()]} | {:ok, []} | {:error, String.t()}
  def list_events() do
    # Get instead of list to pass limit hard threshold as events are very very numerous.
    with {:ok, res} <- Http.get(@endpoint, [limit: 100]) do
      res 
      # These statements have to be commented because incoming data is not fully known.
      # It does not fully match the predefined structure for event entity.
      #|> Utils.keys_to_atoms()
      #|> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> res
    end
  end

  @spec get_event(String.t()) :: {:ok, event()} | {:error, String.t()}
  def get_event(event_id) do
    with {:ok, res} <- Http.get(@endpoint <> "/" <> event_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end
end
