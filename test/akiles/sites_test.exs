defmodule Akiles.SitesTest do
  use ExUnit.Case
  alias Akiles.Site

  test "find_site/1 works well" do
    {:ok, target} = Site.find_site(name: "Prueba")
    assert target.name == "Prueba"
  end
end
