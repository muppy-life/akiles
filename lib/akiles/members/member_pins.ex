defmodule Akiles.MemberPin do
  @moduledoc """
  Module that defines `Akiles Member Pin` entity and the actions available to interact with.
  """

  alias Akiles.Http
  alias Akiles.Utils

  def endpoint(member_id), do: "/members/" <> member_id <> "/pins"

  defstruct [
    :id, :member_id, :length, :pin,
    :is_deleted, :created_at, :metadata
  ]

  @type t() :: %__MODULE__{
    id: term(),
    member_id: term(),
    length: Integer.t(),
    pin: term(),
    is_deleted: boolean(),
    created_at: DateTime.t(),
    metadata: map()
  }

  @doc """
  Lists all member pins.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberPin.list_pins("mem_3merk33gt7ml3tde71f3")
      {:ok, [ %Akiles.MemberPin{
                  "id": "mp_3rkd2fmgmmdh1dgkvluh",
                  "organization_id": "org_3merk33gt1v9ypgfzrp1",
                  "member_id": "mem_3merk33gt7ml3tde71f3",
                  "length": "number (int32)",
                  "is_deleted": false,
                  "created_at": "2018-03-13T16:56:51.766836837Z",
                  "metadata": {
                    "key1": "value1",
                    "key2": "value2"
                  }
                },
                ...
              ]
       }
  """
  @spec list_pins(term()) :: {:ok, [t()]} | {:ok, []} | {:error, term()}
  def list_pins(member_id) do
    with {:ok, res} <- Http.list(endpoint(member_id)) do
      res
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Gets a member pin.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberPin.get_pin("mem_3merk33gt7ml3tde71f3", "mp_3rkd2fmgmmdh1dgkvluh")
      {:ok, %{
            "id": "mp_3rkd2fmgmmdh1dgkvluh",
            "organization_id": "org_3merk33gt1v9ypgfzrp1",
            "member_id": "mem_3merk33gt7ml3tde71f3",
            "length": "number (int32)",
            "is_deleted": false,
            "created_at": "2018-03-13T16:56:51.766836837Z",
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            }
}}
  """
  @spec get_pin(term(), term()) :: {:ok, t()} | {:error, term()}
  def get_pin(member_id, pin_id) do
    with {:ok, res} <- Http.get(endpoint(member_id) <> "/" <> pin_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Creates a member pin.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberPin.create_pin("mem_3merk33gt7ml3tde71f3", %{
                                                              "length": "number (int32)",
                                                              "pin": "string (int32)",
                                                              "metadata": %{
                                                                "key1": "value1",
                                                                "key2": "value2"
                                                              }
                                                            })
      {:ok, %{
            "id": "mp_3rkd2fmgmmdh1dgkvluh",
            "organization_id": "org_3merk33gt1v9ypgfzrp1",
            "member_id": "mem_3merk33gt7ml3tde71f3",
            "length": "number (int32)",
            "is_deleted": false,
            "created_at": "2018-03-13T16:56:51.766836837Z",
            "metadata": %{
              "key1": "value1",
              "key2": "value2"
            }
      }}
  """
  @spec create_pin(term(), map()) :: {:ok, t()} | {:error, term()}
  def create_pin(member_id, data) do
    with {:ok, res} <- Http.post(endpoint(member_id), data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Edits a member pin.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberPin.edit_pin("mem_3merk33gt7ml3tde71f3", "mp_3rkd2fmgmmdh1dgkvluh", %{metadata: %{key1: "val1"}})
      {:ok, %{
              "id": "mp_3rkd2fmgmmdh1dgkvluh",
              "organization_id": "org_3merk33gt1v9ypgfzrp1",
              "member_id": "mem_3merk33gt7ml3tde71f3",
              "length": "number (int32)",
              "is_deleted": false,
              "created_at": "2018-03-13T16:56:51.766836837Z",
              "metadata": {
                "key1": "value1",
                "key2": "value2"
              }
}}
  """
  @spec edit_pin(term(), term(), map()) :: {:ok, t()} | {:error, term()}
  def edit_pin(member_id, pin_id, data) do
    with {:ok, res} <- Http.patch(endpoint(member_id) <> "/" <> pin_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Deletes a member pin.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberPin.delete_pin("mem_3merk33gt7ml3tde71f3", "mp_3rkd2fmgmmdh1dgkvluh")
      {:ok, %{
            "id": "mp_3rkd2fmgmmdh1dgkvluh",
            "organization_id": "org_3merk33gt1v9ypgfzrp1",
            "member_id": "mem_3merk33gt7ml3tde71f3",
            "length": "number (int32)",
            "is_deleted": true,
            "created_at": "2018-03-13T16:56:51.766836837Z",
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            }
}}
  """
  @spec delete_pin(term(), term()) :: {:ok, t()} | {:error, term()}
  def delete_pin(member_id, pin_id) do
    with {:ok, res} <- Http.delete(endpoint(member_id) <> "/" <> pin_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Reveals a member pin.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberPin.reveal_pin("mem_3merk33gt7ml3tde71f3", "mp_3rkd2fmgmmdh1dgkvluh")
      {:ok, %{
            "id": "mp_3rkd2fmgmmdh1dgkvluh",
            "member_id": "mem_3merk33gt7ml3tde71f3",
            "length": "number (int32)",
            "pin": "string",
            "is_deleted": false,
            "created_at": "2018-03-13T16:56:51.766836837Z",
            "metadata": %{
              "key1": "value1",
              "key2": "value2"
            }
}}
  """
  @spec reveal_pin(term(), term()) :: {:ok, t()} | {:error, term()}
  def reveal_pin(member_id, pin_id) do
    with {:ok, res} <- Http.post(endpoint(member_id) <> "/" <> pin_id <> "/reveal", %{}) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
