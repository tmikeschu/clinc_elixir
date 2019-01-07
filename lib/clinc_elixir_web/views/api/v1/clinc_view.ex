defmodule ClincElixirWeb.Api.V1.ClincView do
  use ClincElixirWeb, :view
  require Jason
  require Logger

  def render("query.json", %{request: %{state: "account_and_routing_number"} = body}) do
    Logger.info("XXXXXXXXXXXXXXXXXXXXX HANDLER:  XXXXXXXXXXXXXXXXXXXX")
    Logger.info("XXXXXXXXXXXXXXXXXXXXX REQUEST DATA START XXXXXXXXXXXXXXX")
    Logger.info(Jason.encode!(body))
    Logger.info("XXXXXXXXXXXXXXXXXXXXX REQUEST DATA END   XXXXXXXXXXXXXXX")

    body
  end

  def render("query.json", %{request: body}) do
    Logger.info("XXXXXXXXXXXXXXXXXXXXX HANDLER: NONE XXXXXXXXXXXXXXXXXXXX")
    Logger.info("XXXXXXXXXXXXXXXXXXXXX REQUEST DATA START XXXXXXXXXXXXXXX")
    Logger.info(Jason.encode!(body))
    Logger.info("XXXXXXXXXXXXXXXXXXXXX REQUEST DATA END   XXXXXXXXXXXXXXX")

    body
  end
end
