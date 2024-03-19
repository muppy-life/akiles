defmodule Akiles.Event do
  @moduledoc """
  Module that defines `Akiles Event` entity and the actions available to interact with.
  """

  alias Akiles.Http
  alias Akiles.Utils

  @endpoint "/events"

  defstruct [
    :id,
    :organization_id,
    :subject,
    :verb,
    :object,
    :created_at
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

  @doc """
  Lists te last 100 events.

  Returns `{:ok, %{*cursor_next, data, has_next}}`.

  ## Examples

      iex> Akiles.Http.get("/members/")
      {:ok, %{
              "cursor_next" => "vna9_c92McHWMsr26ytTHs_sHsrLMy4nMZ"
              "data" => [
                %{
                  "created_at" => "2023-03-10T18:35:09.870686208Z",
                  "ends_at" => nil,
                  ...
                },
                ...]
              "has_next" => True
              }
  """
  @spec list_events() :: {:ok, [t()]} | {:ok, []} | {:error, term()}
  def list_events() do
    # Get instead of list to pass limit hard threshold as events are very very numerous.
    with {:ok, res} <- Http.get(@endpoint, limit: 100) do
      res
      # These statements have to be commented because incoming data is not fully known.
      # It does not fully match the predefined structure for event entity.
      # |> Utils.keys_to_atoms()
      # |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Performs a GET for the given event id.

  Returns `{:ok, %{data}}`.

  ## Examples

      iex> Akiles.Event.get_event("evt_3x6k7drxhj4r23l29cyh")
      {:ok, %{

              }
  """
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
