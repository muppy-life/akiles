defmodule Akiles.MemberGroupAssociation do
  @moduledoc """
  Module that defines `Akiles Member Group Association` entity and the actions available to interact with.
  """

  alias Akiles.Http
  alias Akiles.Utils

  def endpoint(member_id), do: "/members/" <> member_id <> "/group_associations"

  defstruct [
    :id, :organization_id, :member_id, :member_group_id, :starts_at, :ends_at,
    :is_deleted, :is_disabled, :created_at, :metadata
  ]

  @type t() :: %__MODULE__{
    id: term(),
    organization_id: term(),
    member_id: term(),
    member_group_id: term(),
    starts_at: DateTime.t(),
    ends_at: DateTime.t(),
    is_deleted: boolean(),
    is_disabled: boolean(),
    created_at: DateTime.t(),
    metadata: map()
  }

  @doc """
  Lists all group associations.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberGroupAssociation.list_group_assoc("mem_3merk33gt7ml3tde71f3")
      {:ok, [
              {
                "id": "mga_3rkd81x2hc3qluv56pl1",
                "organization_id": "org_3merk33gt1v9ypgfzrp1",
                "member_id": "mem_3merk33gt7ml3tde71f3",
                "member_group_id": "mg_3merk33gt1692dk2p2m1",
                "starts_at": "2018-03-13T16:56:51.766836837Z",
                "ends_at": "2018-03-13T16:56:51.766836837Z",
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
  @spec list_group_assoc(term()) :: {:ok, [t()]} | {:ok, []} | {:error, term()}
  def list_group_assoc(member_id) do
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
  Gets the group associations of a member.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberGroupAssociation.get_group_assoc("mem_3merk33gt7ml3tde71f3", "mga_3rkd81x2hc3qluv56pl1")
      {:ok, %{
              "id": "mga_3rkd81x2hc3qluv56pl1",
              "organization_id": "org_3merk33gt1v9ypgfzrp1",
              "member_id": "mem_3merk33gt7ml3tde71f3",
              "member_group_id": "mg_3merk33gt1692dk2p2m1",
              "starts_at": "2018-03-13T16:56:51.766836837Z",
              "ends_at": "2018-03-13T16:56:51.766836837Z",
              "is_deleted": false,
              "created_at": "2018-03-13T16:56:51.766836837Z",
              "metadata": {
                "key1": "value1",
                "key2": "value2"
              }
}}
  """
  @spec get_group_assoc(term(), term()) :: {:ok, t()} | {:error, term()}
  def get_group_assoc(member_id, group_assoc_id) do
    with {:ok, res} <- Http.get(endpoint(member_id) <> "/" <> group_assoc_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

    @doc """
  Creates a member group associations.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberGroupAssociation.create_group_assoc("mem_3x9992bcnhjypy4d8pj1" %{
                                                                                      "member_group_id": "mg_3merk33gt1692dk2p2m1",
                                                                                      "starts_at": "2018-03-13T16:56:51.766836837Z",
                                                                                      "ends_at": "2018-03-13T16:56:51.766836837Z",
                                                                                      "metadata": {
                                                                                        "key1": "value1",
                                                                                        "key2": "value2"
                                                                                      }
      })
      {:ok, %{
          "id": "mga_3rkd81x2hc3qluv56pl1",
          "organization_id": "org_3merk33gt1v9ypgfzrp1",
          "member_id": "mem_3merk33gt7ml3tde71f3",
          "member_group_id": "mg_3merk33gt1692dk2p2m1",
          "starts_at": "2018-03-13T16:56:51.766836837Z",
          "ends_at": "2018-03-13T16:56:51.766836837Z",
          "is_deleted": false,
          "created_at": "2018-03-13T16:56:51.766836837Z",
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          }
}}
  """
  @spec create_group_assoc(term(), map()) :: {:ok, t()} | {:error, term()}
  def create_group_assoc(member_id, data) do
    with {:ok, res} <- Http.post(endpoint(member_id), data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Edits a member group associations <- Adds key/value pairs to the metadata attribute

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberGroupAssociation.edit_group_assoc("mem_3merk33gt7ml3tde71f3", "mga_3rkd81x2hc3qluv56pl1", {
                                                                                                      "starts_at": "2018-03-13T16:56:51.766836837Z",
                                                                                                      "ends_at": "2018-03-13T16:56:51.766836837Z",
                                                                                                      "metadata": {
                                                                                                        "key1": "value1",
                                                                                                        "key2": "value2"
                                                                                                      }
                                                                                                    })
      {:ok, %{
                "id": "mga_3rkd81x2hc3qluv56pl1",
                "organization_id": "org_3merk33gt1v9ypgfzrp1",
                "member_id": "mem_3merk33gt7ml3tde71f3",
                "member_group_id": "mg_3merk33gt1692dk2p2m1",
                "starts_at": "2018-03-13T16:56:51.766836837Z",
                "ends_at": "2018-03-13T16:56:51.766836837Z",
                "is_deleted": false,
                "created_at": "2018-03-13T16:56:51.766836837Z",
                "metadata": {
                  "key1": "value1",
                  "key2": "value2"
                }
              }
}
  """
  @spec edit_group_assoc(term(), term(), map()) :: {:ok, t()} | {:error, term()}
  def edit_group_assoc(member_id, group_assoc_id, data) do
    with {:ok, res} <- Http.patch(endpoint(member_id) <> "/" <> group_assoc_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Deletes the given group association.

  Returns `{:ok, data}`

  ## Examples

    iex> Akiles.MemberGroupAssociation.delete_group_assoc("mem_3merk33gt7ml3tde71f3", "mga_3rkd81x2hc3qluv56pl1")
    {:ok, %{
            "id": "mga_3rkd81x2hc3qluv56pl1",
            "organization_id": "org_3merk33gt1v9ypgfzrp1",
            "member_id": "mem_3merk33gt7ml3tde71f3",
            "member_group_id": "mg_3merk33gt1692dk2p2m1",
            "starts_at": "2018-03-13T16:56:51.766836837Z",
            "ends_at": "2018-03-13T16:56:51.766836837Z",
            "is_deleted": false,
            "created_at": "2018-03-13T16:56:51.766836837Z",
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            }
    }}
  """
  @spec delete_group_assoc(term(), term()) :: {:ok, t()} | {:error, term()}
  def delete_group_assoc(member_id, group_assoc_id) do
    with {:ok, res} <- Http.delete(endpoint(member_id) <> "/" <> group_assoc_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
