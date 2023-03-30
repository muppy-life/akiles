defmodule Akiles.EventsTest do
  use ExUnit.Case

  test "list_events/0 works well" do
    assert {:ok, data} = Akiles.Event.list_events
    assert 100 = length(data["data"])
  end


end
