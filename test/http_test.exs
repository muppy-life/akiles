defmodule AkilesTest.Http do
  use ExUnit.Case

  test "verbs post, get, & delete work good" do
    input_data = %{name: "John Doe"}
    assert {:ok, data} = Akiles.Http.post("/members", input_data)
    assert data["name"] == input_data.name
    assert {:ok, data} = Akiles.Http.get("/members/" <> data["id"])
    assert {:ok, _data} = Akiles.Http.delete("/members/" <> data["id"])
  end

  test "akiles api errors are well digested" do
    assert {:error, _msg} = Akiles.Http.get("fake_endpoint")
  end

  test "verb patch works well" do
    input_data = %{name: "Jonathan Doe"}
    {:ok, data} = Akiles.Http.post("/members", input_data)
    assert data["metadata"] == %{}
    assert {:ok, data} = Akiles.Http.patch("/members/" <> data["id"], %{"metadata": %{test_key: "test_value"}})
    assert {:ok, _data} = Akiles.Http.delete("/members/" <> data["id"])
    assert data["metadata"] == %{"test_key"=> "test_value"}
  end


end
