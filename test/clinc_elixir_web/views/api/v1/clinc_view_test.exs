defmodule ClincElixirWeb.Api.V1.ClincViewTest do
  use ClincElixirWeb.ConnCase, async: true

  import Phoenix.View

  alias ClincElixirWeb.Api.V1.ClincView

  @request %{
    ai_version: "0634e1e2-7392-4550-824a-e4ec201e93c1",
    device: "default",
    dialaog: "HL4JqjMHT0jLPRe3X0nni5Ic5mtFtTN6",
    external_user_id: "1",
    intent: "account_and_routing_number_start",
    intent_probability: 0.6871070981756203,
    lat: 0,
    lon: 0,
    qid: "97c60b18-dfb5-446d-a3dc-d53db4a34ebab",
    query: "what is my account and routing number",
    sentiment: 0,
    session_id: "edb7a711408444bbac9d54e14dfa43f9",
    slots: %{},
    state: "account_and_routing_number",
    time_offset: 0
  }

  test "renders query.json for no slots and account_and_routing_number_start" do
    actual = render(ClincView, "query.json", %{request: @request})

    expected =
      @request
      |> put_in(
        [:slots, :_ACCOUNTS_],
        %{type: "string", values: [%{account_id: 10, resolved: 1}]}
      )
      |> Map.replace!(:state, "account_and_routing_number_otp")

    assert actual == expected
  end
end
