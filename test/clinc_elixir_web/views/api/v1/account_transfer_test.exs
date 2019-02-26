defmodule ClincElixirWeb.Api.V1.AccountTransferTest do
  use ClincElixirWeb.ConnCase, async: true

  require Factories
  alias ClincElixirWeb.Api.V1.{AccountTransfer}

  @with_slots Map.merge(Factories.base_request(), %{
                state: "account_transfer_confirmed",
                slots: %{
                  _SOURCE_ACCOUNT_: %{
                    type: "string",
                    values: [
                      %{
                        tokens: "checking",
                        resolved: -1
                      }
                    ]
                  },
                  _DESTINATION_ACCOUNT_: %{
                    type: "string",
                    values: [
                      %{
                        tokens: "savings",
                        resolved: -1
                      }
                    ]
                  },
                  _AMOUNT_: %{
                    type: "string",
                    values: [
                      %{
                        tokens: "400",
                        resolved: -1
                      }
                    ]
                  }
                }
              })

  test "transfers money for valid data" do
    request = @with_slots

    actual = AccountTransfer.render(Factories.accounts(), %{request: request})

    response_data = %{
      response_key: "transfer_success",
      new_source_balance: 3600,
      new_destination_balance: 600
    }

    expected_response_slots = %{
      response_type: "account_transfer_confirmed",
      speakables: response_data,
      visuals: response_data
    }

    assert actual.response_slots == expected_response_slots
  end

  test "handles insufficient funds" do
    request =
      update_in(@with_slots.slots._AMOUNT_.values, fn [v | rest] ->
        [%{v | tokens: "50000"} | rest]
      end)

    actual = AccountTransfer.render(Factories.accounts(), %{request: request})

    response_data = %{
      response_key: "insufficient_funds"
    }

    expected_response_slots = %{
      response_type: "account_transfer_confirmed",
      speakables: response_data,
      visuals: response_data
    }

    assert actual.response_slots == expected_response_slots
  end
end
