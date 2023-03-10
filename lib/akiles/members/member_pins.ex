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
