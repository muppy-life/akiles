defmodule Akiles.Utils do
  def keys_to_atoms(json) when is_map(json), do: Map.new(json, &reduce_keys_to_atoms/1)

  def keys_to_atoms(list) when is_list(list),
    do: Enum.map(list, &Map.new(&1, fn x -> reduce_keys_to_atoms(x) end))

  def reduce_keys_to_atoms({key, val}) when is_map(val),
    do: {manage_to_existing_atom(key), keys_to_atoms(val)}

  def reduce_keys_to_atoms({key, val}) when is_list(val),
    do: {manage_to_existing_atom(key), Enum.map(val, &keys_to_atoms(&1))}

  def reduce_keys_to_atoms({key, val}), do: {manage_to_existing_atom(key), val}

  def manage_error(res), do: manage_error(res, nil)
  def manage_error({:error, msg}, nil), do: {:error, msg}
  def manage_error({:error, msg}, context), do: {:error, "[#{context}] " <> msg}
  def manage_error(_res, context), do: {:error, "[#{context}] " <> "Unexpected error!"}

  defp manage_to_existing_atom(val) do
    try do
      String.to_existing_atom(val)
    rescue
      ArgumentError -> val
    end
  end
end
