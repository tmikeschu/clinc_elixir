defmodule ClincElixirWeb.Api.V1.GetBalance do
  use ClincElixirWeb.Api.V1.Renderer

  # fake account data
  # toggle comment on second element to trigger multiple/single accounts

  @accounts [
    %{
      type: :checking,
      id: 10,
      account: 1234,
      routing: 4321,
      balance: 4000
    },
    %{
      type: :savings,
      id: 101,
      account: 7890,
      routing: 9087,
      balance: 200
    }
  ]

  @doc """
  Get balance when slot is provided
  """
  def render(%{
        request:
          body = %{
            state: "get_balance" = state,
            slots: %{
              _SOURCE_ACCOUNT_: %{
                values: [%{tokens: tokens} | _]
              }
            }
          }
      }) do
    handling = "GET_BALANCE_WITH_SLOT"

    account =
      @accounts
      |> Enum.find(&(&1.type == String.to_atom(tokens)))

    case account do
      nil ->
        body
        |> log(:req, handling)
        |> resolve_slot(:_SOURCE_ACCOUNT_)
        |> add_response_slots(state, %{response_key: "no_account_found", acct_type: tokens})
        |> log(:res, handling)

      x ->
        body
        |> log(:req, handling)
        |> resolve_slot(:_SOURCE_ACCOUNT_)
        |> add_response_slots(state, %{
          response_key: "balance",
          balance: x.balance,
          acct_type: tokens
        })
        |> add_visual_data(%{account: x})
        |> log(:res, handling)
    end
  end

  @doc """
  Handles get_balance without slots. Chooses first account.
  """
  def render(%{
        request:
          body = %{
            state: state = "get_balance",
            slots: %{}
          }
      }) do
    handling = "GET_BALANCE_NO_SLOTS"

    account = @accounts |> List.first()

    body
    |> log(:req, handling)
    |> add_response_slots(state, %{
      response_key: "balance_default",
      acct_type: Atom.to_string(account.type),
      balance: account.balance
    })
    |> log(:res, handling)
  end
end
