defmodule ClincElixirWeb.Api.V1.ClincView do
  use ClincElixirWeb, :view
  alias ClincElixirWeb.Api.V1.{AccountAndRoutingNumber, Default}

  @renderers %{
    "account_and_routing_number" => AccountAndRoutingNumber,
    "account_and_routing_number_otp" => AccountAndRoutingNumber
  }

  def render("query.json", data = %{request: %{state: state}}) do
    Map.get(@renderers, state, Default).render(data)
  end
end
