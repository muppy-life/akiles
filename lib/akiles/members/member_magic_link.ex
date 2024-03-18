defmodule Akiles.MemberMagicLink do
  @moduledoc """
  Module that defines `Akiles Member Pin` entity and the actions available to interact with.
  """

  alias Akiles.Http
  alias Akiles.Utils

  def endpoint(member_id), do: "/members/" <> member_id <> "/magic_links"

  defstruct [
    :id,
    :organization_id,
    :member_id,
    :is_deleted,
    :created_at,
    :metadata,
    :link
  ]

  @type t() :: %__MODULE__{
          id: term(),
          organization_id: term(),
          member_id: term(),
          is_deleted: boolean(),
          created_at: DateTime.t(),
          link: term(),
          metadata: map()
        }

  @doc """
  Lists all member magic links.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberPin.list_pins("mem_3merk33gt7ml3tde71f3")
      {:ok, [ %Akiles.MemberMagicLink{
                  "id": "mml_3rkd2f2mv925ptvpgblh",
                  "organization_id": "org_3merk33gt1v9ypgfzrp1",
                  "member_id": "mem_3merk33gt7ml3tde71f3",
                  "is_deleted": false,
                  "created_at": "2018-03-13T16:56:51.766836837Z",
                  "metadata": {
                    "key1": "value1",
                    "key2": "value2"
                  }
                },
                ...
              ]}
  """
  @spec list_magic_links(term()) :: {:ok, [t()]} | {:ok, []} | {:error, term()}
  def list_magic_links(member_id) do
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
  Creates a member magic link.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberPin.create_magic_link("mem_3merk33gt7ml3tde71f3", %{metadata: %{key1: "val1"}})
      {:ok, %Akiles.MemberMagicLink{
                  "id": "mml_3rkd2f2mv925ptvpgblh",
                  "organization_id": "org_3merk33gt1v9ypgfzrp1",
                  "member_id": "mem_3merk33gt7ml3tde71f3",
                  "is_deleted": false,
                  "created_at": "2018-03-13T16:56:51.766836837Z",
                  "metadata": {
                    "key1": "val1"
                  }
                }
              }
  """
  def create_magic_link(member_id, data) do
    with {:ok, res} <- Http.post(endpoint(member_id), data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Gets a member magic link.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberPin.get_magic_link("mem_3merk33gt7ml3tde71f3", "mml_3rkd2f2mv925ptvpgblh")
      {:ok, %Akiles.MemberMagicLink{
                  "id": "mml_3rkd2f2mv925ptvpgblh",
                  "organization_id": "org_3merk33gt1v9ypgfzrp1",
                  "member_id": "mem_3merk33gt7ml3tde71f3",
                  "is_deleted": false,
                  "created_at": "2018-03-13T16:56:51.766836837Z",
                  "metadata": {
                    "key1": "val1"
                  }
                }
              }
  """
  def get_magic_link(member_id, magic_link_id) do
    with {:ok, res} <- Http.get(endpoint(member_id) <> "/" <> magic_link_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Edits a member magic link.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberMagicLink.edit_magic_link("mem_3merk33gt7ml3tde71f3", "mml_3rkd2f2mv925ptvpgblh", %{metadata: %{key1: "val1"}})
      {:ok, %Akiles.MemberMagicLink{
                "id": "mml_3rkd2f2mv925ptvpgblh",
                "organization_id": "org_3merk33gt1v9ypgfzrp1",
                "member_id": "mem_3merk33gt7ml3tde71f3",
                "is_deleted": false,
                "created_at": "2018-03-13T16:56:51.766836837Z",
                "metadata": {
                  "key1": "val1"
                }
              }
      }
  """
  def edit_magic_link(member_id, magic_link_id, data) do
    with {:ok, res} <- Http.patch(endpoint(member_id) <> "/" <> magic_link_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Deletes a member magic link.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberMagicLink.edit_magic_link("mem_3merk33gt7ml3tde71f3", "mml_3rkd2f2mv925ptvpgblh", %{metadata: %{key1: "val1"}})
      {:ok, %Akiles.MemberMagicLink{
                "id": "mml_3rkd2f2mv925ptvpgblh",
                "organization_id": "org_3merk33gt1v9ypgfzrp1",
                "member_id": "mem_3merk33gt7ml3tde71f3",
                "is_deleted": true,
                "created_at": "2018-03-13T16:56:51.766836837Z",
                "metadata": {
                  "key1": "val1"
                }
              }
      }
  """
  def delete_magic_link(member_id, magic_link_id) do
    with {:ok, res} <- Http.delete(endpoint(member_id) <> "/" <> magic_link_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end

  @doc """
  Reveals a member magic link.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.MemberMagicLink.reveal_magic_link("mem_3merk33gt7ml3tde71f3", "mml_3rkd2f2mv925ptvpgblh"})
      {:ok, %{
              "link": "https://link.akiles.app/#ml_8502850982345_f00i1nslz20gkm"
            }
      }
  """
  def reveal_magic_link(member_id, magic_link_id) do
    with {:ok, res} <- Http.post(endpoint(member_id) <> "/" <> magic_link_id <> "/reveal", %{}) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, &1})
    else
      res -> Utils.manage_error(res, __MODULE__)
    end
  end
end
