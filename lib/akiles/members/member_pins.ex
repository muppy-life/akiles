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

  @type member_pin() :: %__MODULE__{
    id: String.t(),
    member_id: String.t(),
    length: Integer.t(),
    pin: String.t(),
    is_deleted: boolean(),
    created_at: DateTime.t(),
    metadata: Map.t()
  }

  @spec list_pins(String.t()) :: {:ok, [member_pin()]} | {:ok, []} | {:error, String.t()}
  def list_pins(member_id) do
    with {:ok, res} <- Http.list(endpoint(member_id)) do
      res 
      |> Utils.keys_to_atoms()
      |> Enum.map(&struct!(%__MODULE__{}, &1))
      |> then(&{:ok, &1})
    else
      res -> res
    end
  end

  @spec get_pin(String.t(), String.t()) :: {:ok, member_pin()} | {:error, String.t()}
  def get_pin(member_id, pin_id) do
    with {:ok, res} <- Http.get(endpoint(member_id) <> "/" <> pin_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec create_pin(String.t(), Map.t()) :: {:ok, member_pin()} | {:error, String.t()}
  def create_pin(member_id, data) do
    with {:ok, res} <- Http.post(endpoint(member_id), data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec edit_pin(String.t(), String.t(), Map.t()) :: {:ok, member_pin()} | {:error, String.t()}
  def edit_pin(member_id, pin_id, data) do
    with {:ok, res} <- Http.patch(endpoint(member_id) <> "/" <> pin_id, data) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec delete_pin(String.t(), String.t()) :: {:ok, member_pin()} | {:error, String.t()}
  def delete_pin(member_id, pin_id) do
    with {:ok, res} <- Http.delete(endpoint(member_id) <> "/" <> pin_id) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end

  @spec reveal_pin(String.t(), String.t()) :: {:ok, member_pin()} | {:error, String.t()}
  def reveal_pin(member_id, pin_id) do
    with {:ok, res} <- Http.post(endpoint(member_id) <> "/" <> pin_id <> "/reveal", %{}) do
      res
      |> Utils.keys_to_atoms()
      |> then(&{:ok, struct!(%__MODULE__{}, &1)})
    else
      res -> res
    end
  end
end
