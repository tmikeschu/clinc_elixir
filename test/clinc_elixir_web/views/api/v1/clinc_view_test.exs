defmodule ClincElixirWeb.Api.V1.ClincViewTest do
  use ClincElixirWeb.ConnCase, async: true

  import Phoenix.View

  alias ClincElixirWeb.Api.V1.ClincView

  @request %{
    ai_version: "0634e1e2-7392-4550-824a-e4ec201e93c1",
    device: "default",
    dialaog: "HL4JqjMHT0jLPRe3X0nni5Ic5mtFtTN6",
    external_user_id: "1",
    intent: "unknown",
    intent_probability: 0.6871070981756203,
    lat: 0,
    lon: 0,
    qid: "97c60b18-dfb5-446d-a3dc-d53db4a34ebab",
    query: "blah blah blah blah blah blah blah blah blah blah blah blah",
    sentiment: 0,
    session_id: "edb7a711408444bbac9d54e14dfa43f9",
    slots: %{},
    state: "unknown",
    time_offset: 0
  }

  test "handles unconfigured state with empty response" do
    actual = render(ClincView, "query.json", %{request: @request})
    assert actual == %{}
  end
end
