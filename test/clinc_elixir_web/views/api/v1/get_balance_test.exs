defmodule ClincElixirWeb.Api.V1.GetBalanceTest do
  use ClincElixirWeb.ConnCase, async: true

  alias ClincElixirWeb.Api.V1.GetBalance

  @base_request %{
    ai_version: "0634e1e2-7392-4550-824a-e4ec201e93c1",
    device: "default",
    dialaog: "HL4JqjMHT0jLPRe3X0nni5Ic5mtFtTN6",
    external_user_id: "1",
    intent: "get_balance_start",
    intent_probability: 0.6871070981756203,
    lat: 0,
    lon: 0,
    qid: "97c60b18-dfb5-446d-a3dc-d53db4a34ebab",
    query: "what is my balance",
    sentiment: 0,
    session_id: "edb7a711408444bbac9d54e14dfa43f9",
    slots: %{},
    state: "get_balance",
    time_offset: 0
  }

  test "gets balance with no slots provided" do
    actual = GetBalance.render(%{request: @base_request})

    response_data = %{
      response_key: "balance_default",
      acct_type: "checking",
      balance: 4000
    }

    expected_response_slots = %{
      response_type: "get_balance",
      speakables: response_data,
      visuals: response_data
    }

    assert actual.response_slots == expected_response_slots
  end

  test "gets balance with valid slot" do
    request =
      Map.merge(@base_request, %{
        slots: %{
          _SOURCE_ACCOUNT_: %{
            type: "string",
            values: [
              %{resolved: -1, tokens: "checking"}
            ]
          }
        }
      })

    actual = GetBalance.render(%{request: request})

    expected_slots = %{
      _SOURCE_ACCOUNT_: %{
        type: "string",
        values: [
          %{resolved: 1, tokens: "checking"}
        ]
      },
      _FEE_: %{
        type: "string",
        values: [
          %{resolved: 1, value: 10}
        ]
      }
    }

    response_data = %{
      response_key: "balance",
      acct_type: "checking",
      balance: 4000
    }

    expected_response_slots = %{
      response_type: "get_balance",
      speakables: response_data,
      visuals: response_data
    }

    assert actual.slots == expected_slots
    assert actual.response_slots == expected_response_slots
  end

  test "handles invalid slot" do
    request =
      Map.merge(@base_request, %{
        slots: %{
          _SOURCE_ACCOUNT_: %{
            type: "string",
            values: [
              %{resolved: -1, tokens: "blah blah blah"}
            ]
          }
        }
      })

    actual = GetBalance.render(%{request: request})

    expected_slots = %{
      _SOURCE_ACCOUNT_: %{
        type: "string",
        values: [
          %{resolved: 1, tokens: "blah blah blah"}
        ]
      }
    }

    response_data = %{
      response_key: "no_account_found",
      acct_type: "blah blah blah"
    }

    expected_response_slots = %{
      response_type: "get_balance",
      speakables: response_data,
      visuals: response_data
    }

    assert actual.slots == expected_slots
    assert actual.response_slots == expected_response_slots
  end
end
