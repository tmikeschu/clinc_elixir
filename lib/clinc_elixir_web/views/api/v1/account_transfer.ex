defmodule ClincElixirWeb.Api.V1.AccountTransfer do
  use ClincElixirWeb.Api.V1.Renderer

  def render(data) do
    # handle data source logic here
    accounts = [
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

    render(accounts, data)
  end

  @doc """
  Make the transaction
  """
  def render(accounts, %{
        request:
          body = %{
            state: "acct_transfer_confirmed" = state,
            slots: %{
              _SOURCE_ACCOUNT_: %{
                values: [%{tokens: source_token} | _]
              },
              _DESTINATION_ACCOUNT_: %{
                values: [%{tokens: destination_token} | _]
              },
              _AMOUNT_: %{
                values: [%{tokens: amount_token} | _]
              }
            }
          }
      }) do
    handling = "ACCOUNT_TRANSFER_CONFIRMED"

    source = accounts |> Enum.find(&(&1.type == String.to_atom(source_token)))
    destination = accounts |> Enum.find(&(&1.type == String.to_atom(destination_token)))
    {amount, _} = Float.parse(amount_token)

    case {source, destination, amount <= source.balance} do
      {nil, _, _} ->
        body
        |> log(:req, handling)
        |> add_response_slots(state, %{response_key: "invalid_source"})
        |> log(:res, handling)

      {_, nil, _} ->
        body
        |> log(:req, handling)
        |> add_response_slots(state, %{response_key: "invalid_destination"})
        |> log(:res, handling)

      {_, _, false} ->
        body
        |> log(:req, handling)
        |> add_response_slots(state, %{response_key: "insufficient_funds"})
        |> log(:res, handling)

      _ ->
        body
        |> log(:req, handling)
        |> resolve_slots([:_SOURCE_ACCOUNT_, :_DESTINATION_ACCOUNT_, :_AMOUNT_])
        |> make_transfer(%{source: source, destination: destination, amount: amount, state: state})
        |> log(:res, handling)
    end
  end

  defp make_transfer(body, %{source: s, destination: d, amount: a, state: st}) do
    case true do
      true ->
        body
        |> add_response_slots(st, %{
          response_key: "transfer_success",
          new_source_balance: s.balance - a,
          new_destination_balance: d.balance + a
        })

      _ ->
        body |> add_response_slots(st, %{response_key: "transfer_failure"})
    end
  end
end
