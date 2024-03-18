defmodule Akiles.EventsTest do
  use ExUnit.Case
  alias Akiles.Event

  test "list_events/0 works well" do
    assert {:ok, data} = Event.list_events()
    assert 100 = length(data["data"])
  end
end
