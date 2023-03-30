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

  @doc """
  Performs an HTTP 'GET' action for the Organization.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Http.get_organization
      %Akiles.Organization{
        "created_at" => "2023-03-10T18:35:09.870686208Z",
        "id" => "org_3x5bggk73t6d37ubd7vh",
        ...
      }
  """
  @spec get_organization() :: {:ok, t()} | {:error, term()}
  def get_organization() do
    with {:ok, res} <- Http.get(@endpoint) do
      res |> Utils.keys_to_atoms() |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Adds key value pairs to the metadata map of the Organozation.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Http.edit_organization(%{key1: "val1", key2: "val2"})
      {:ok, %Akiles.Organization{
        "created_at" => "2023-03-10T18:35:09.870686208Z",
        "id" => "org_3x5bggk73t6d37ubd7vh",
        ...
        metadata: %{key1: "val1",
                    key2: "val2"}
      }}
  """
  @spec edit_organization(Map.t()) :: {:ok, t()} | {:error, term()}
  def edit_organization(data) do
    with {:ok, res} <- Http.patch(@endpoint, %{metadata: data}) do
      res |> Utils.keys_to_atoms() |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
