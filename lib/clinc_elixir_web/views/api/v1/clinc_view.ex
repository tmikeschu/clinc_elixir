defmodule ClincElixirWeb.Api.V1.ClincView do
  use ClincElixirWeb, :view
  alias ClincElixirWeb.Api.V1.{AccountAndRoutingNumber, GetBalance, AccountTransfer}

  @renderers %{
    "account_and_routing_number" => AccountAndRoutingNumber,
    "account_and_routing_number_otp" => AccountAndRoutingNumber,
    "account_transfer_confirmed" => AccountTransfer,
    "get_balance" => GetBalance
  }

  def render("query.json", data = %{request: %{state: state}}) do
    Map.fetch!(@renderers, state).render(data)
  end
end
