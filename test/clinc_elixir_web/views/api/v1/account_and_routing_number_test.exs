defmodule ClincElixirWeb.Api.V1.AccountAndRoutingNumberTest do
  use ClincElixirWeb.ConnCase, async: true

  alias ClincElixirWeb.Api.V1.AccountAndRoutingNumber

  @base_request %{
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

  test "handles no slots and account_and_routing_number state" do
    actual = AccountAndRoutingNumber.render(%{request: @base_request})

    expected_slots = %{
      _ACCOUNTS_: %{
        type: "string",
        values: [
          %{resolved: 1, account_id: 10},
          %{resolved: 1, account_id: 101}
        ]
      }
    }

    assert actual.slots == expected_slots
    assert actual.state == "account_and_routing_number_otp"
  end

  test "handles slots and account_and_routing_number state" do
    request =
      Map.merge(
        @base_request,
        %{
          slots: %{
            _ACCOUNTS_: %{
              type: "string",
              values: [%{tokens: "checking", account_dest: "checking", resolved: -1}]
            }
          }
        }
      )

    actual = AccountAndRoutingNumber.render(%{request: request})

    expected_slots = %{
      _ACCOUNTS_: %{
        type: "string",
        values: [
          %{tokens: "checking", account_dest: "checking", resolved: 1, account_id: 10}
        ]
      }
    }

    assert actual.slots == expected_slots
    assert actual.state == "account_and_routing_number_otp"
  end

  test "sets otp_init key" do
    request =
      Map.merge(
        @base_request,
        %{
          state: "account_and_routing_number_otp",
          intent: "account_and_routing_number_start"
        }
      )

    actual = AccountAndRoutingNumber.render(%{request: request})

    expected_response_slots = %{
      response_type: "account_and_routing_number_otp",
      speakables: %{response_key: "otp_init"},
      visuals: %{response_key: "otp_init"}
    }

    assert actual.response_slots == expected_response_slots
  end

  test "validates query as otp" do
    request =
      Map.merge(
        @base_request,
        %{
          query: "123456",
          state: "account_and_routing_number_otp",
          intent: "account_and_routing_number_otp_update"
        }
      )

    actual = AccountAndRoutingNumber.render(%{request: request})
    assert actual.state == "account_and_routing_number"
  end

  test "handles invalid passwords" do
    request =
      Map.merge(
        @base_request,
        %{
          query: "009876",
          state: "account_and_routing_number_otp",
          intent: "account_and_routing_number_otp_update",
          slots: %{
            _ACCOUNTS_: %{
              values: [
                %{tokens: "checking", account_dest: "checking", resolved: 1, account_id: 10}
              ]
            }
          }
        }
      )

    actual = AccountAndRoutingNumber.render(%{request: request})

    expected_response_slots = %{
      response_type: "account_and_routing_number_otp",
      speakables: %{response_key: "otp_incorrect"},
      visuals: %{response_key: "otp_incorrect"}
    }

    assert actual.response_slots == expected_response_slots
  end

  test "handles successful otp redirect" do
    request =
      Map.merge(
        @base_request,
        %{
          state: "account_and_routing_number",
          intent: "account_and_routing_number_otp_update",
          slots: %{
            _ACCOUNTS_: %{
              values: [
                %{tokens: "checking", account_dest: "checking", resolved: 1, account_id: 10}
              ]
            }
          }
        }
      )

    actual = AccountAndRoutingNumber.render(%{request: request})

    response_data = %{
      response_key: "single_account",
      accounts: [
        %{
          type: :checking,
          id: 10,
          account: 1234,
          routing: 4321
        }
      ]
    }

    expected_response_slots = %{
      response_type: "account_and_routing_number",
      speakables: response_data,
      visuals: response_data
    }

    assert actual.response_slots == expected_response_slots
  end

  test "handles successful otp redirect for two accounts" do
    request =
      Map.merge(
        @base_request,
        %{
          state: "account_and_routing_number",
          intent: "account_and_routing_number_otp_update",
          slots: %{
            _ACCOUNTS_: %{
              values: [
                %{resolved: 1, account_id: 10},
                %{resolved: 1, account_id: 101}
              ]
            }
          }
        }
      )

    actual = AccountAndRoutingNumber.render(%{request: request})

    response_data = %{
      response_key: "multiple_accounts",
      accounts: [
        %{
          type: :checking,
          id: 10,
          account: 1234,
          routing: 4321
        },
        %{
          type: :savings,
          id: 101,
          account: 7890,
          routing: 9087
        }
      ]
    }

    expected_response_slots = %{
      response_type: "account_and_routing_number",
      speakables: response_data,
      visuals: response_data
    }

    assert actual.response_slots == expected_response_slots
  end
end
