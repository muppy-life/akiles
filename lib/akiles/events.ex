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
    type: term(),
    member_id: term(),
    user_id: term(),
    user_session_id: term(),
    api_key_id: term(),
    admin_id: term()
  }

  @type event_verb() :: :create | :edit | :delete | :use

  @type event_object() :: %{
    type: term(), 
    admin_id: term(), 
    api_key_id: term(),
    device_id: term(),
    gadget_id: term(),
    link_id: term(),
    member_id: term(),
    member_event_id: term(),
    member_invitation_id: term(),
    site_id: term(),
    gadget_action_id: term()
  }

  @type t() :: %__MODULE__{
    id: term(),
    organization_id: term(),
    subject: event_subject(),
    verb: event_verb(),
    object: event_object(),
    created_at: DateTime.t()
  }

  @spec list_events() :: {:ok, [t()]} | {:ok, []} | {:error, term()}
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
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @spec get_event(term()) :: {:ok, t()} | {:error, term()}
  def get_event(event_id) do
    with {:ok, res} <- Http.get(@endpoint <> "/" <> event_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
