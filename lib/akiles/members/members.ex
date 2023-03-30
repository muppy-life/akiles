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

  @doc """
  Lists all members.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Member.list_members
      {:ok, [
            %Akiles.Member{
              created_at: "2023-03-27T07:41:48.976726016Z",
              ends_at: nil,
              id: "mem_3x94ekvkpka51x1a1xkh",
              is_deleted: false,
              is_disabled: nil,
              metadata: %{},
              name: "Jonathan Doe",
              organization_id: "org_3x5bggk73t6d37ubd7vh",
              starts_at: nil
            },
            ...]
  """
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

  @doc """
  Get member data from Id.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Member.get_member("mem_3x6j42fm26t6cy3zkhyh")
      {:ok, %Akiles.Member{
              created_at: "2023-03-10T13:22:32.611323904Z",
              ends_at: nil,
              id: "mem_3x6j42fm26t6cy3zkhyh",
              is_deleted: false,
              is_disabled: nil,
              metadata: %{},
              name: "John Doe",
              organization_id: "org_3x5bggk73t6d37ubd7vh",
              starts_at: nil
            }}
  """
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

  @doc """
  Creates member.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Member.create_member(%{
                            "name": "John Doe",
                            "starts_at": "2018-03-13T16:56:51.766836837Z",
                            "ends_at": "2018-03-13T16:56:51.766836837Z",
                            "metadata": {
                              "key1": "value1",
                              "key2": "value2"
                            }})
      {:ok, %Akiles.Member{
                          "id": "mem_3merk33gt7ml3tde71f3",
                          "organization_id": "org_3merk33gt1v9ypgfzrp1",
                          "name": "John Doe",
                          "starts_at": "2018-03-13T16:56:51.766836837Z",
                          "ends_at": "2018-03-13T16:56:51.766836837Z",
                          "is_deleted": false,
                          "created_at": "2018-03-13T16:56:51.766836837Z",
                          "metadata": {
                            "key1": "value1",
                            "key2": "value2"
                          }
                          }
  """
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

  @doc """
  Edits the member data -> Adds key value pairs to the metadata.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Member.edit_member("mem_3merk33gt7ml3tde71f3", %{
                            "name": "John Doe",
                            "starts_at": "2018-03-13T16:56:51.766836837Z",
                            "ends_at": "2018-03-13T16:56:51.766836837Z",
                            "metadata": {
                              "new_key": "new_value",
                            }})
      {:ok, %Akiles.Member{
                          "id": "mem_3merk33gt7ml3tde71f3",
                          "organization_id": "org_3merk33gt1v9ypgfzrp1",
                          "name": "John Doe",
                          "starts_at": "2018-03-13T16:56:51.766836837Z",
                          "ends_at": "2018-03-13T16:56:51.766836837Z",
                          "is_deleted": false,
                          "created_at": "2018-03-13T16:56:51.766836837Z",
                          "metadata": {
                            "key1": "value1",
                            "new_key": "new_value"
                          }
                          }
  """
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

  @doc """
  Deletes a member by their Id.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Member.delete_member("mem_3merk33gt7ml3tde71f3")
      {:ok, %Akiles.Member{
                          "id": "mem_3merk33gt7ml3tde71f3",
                          "organization_id": "org_3merk33gt1v9ypgfzrp1",
                          "name": "John Doe",
                          "starts_at": "2018-03-13T16:56:51.766836837Z",
                          "ends_at": "2018-03-13T16:56:51.766836837Z",
                          "is_deleted": true,
                          "created_at": "2018-03-13T16:56:51.766836837Z",
                          "metadata": {
                            "key1": "value1",
                            "new_key": "new_value"
                          }
                          }
  """
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
