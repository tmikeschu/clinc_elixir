defmodule ClincElixirWeb.Api.V1.ClincView do
  use ClincElixirWeb, :view
  require Jason
  require Logger

  def render("query.json", %{
        request:
          body = %{
            state: "account_and_routing_number",
            slots:
              slots = %{
                _ACCOUNTS_:
                  accounts = %{
                    values: [value | values]
                  }
              },
            intent: "account_and_routing_number_start"
          }
      }) do
    log(:req, %{handling: "FROM_ROOT_WITH_QUALIFIER", data: body})

    resp = %{
      body
      | slots: %{
          slots
          | _ACCOUNTS_: %{
              accounts
              | values: [%{value | resolved: 1} | values]
            }
        }
    }

    log(:res, %{handling: "FROM_ROOT_WITH_QUALIFIER", data: resp})

    resp
  end

  def render("query.json", %{
        request:
          %{
            state: "account_and_routing_number",
            slots: %{},
            intent: "account_and_routing_number_start"
          } = body
      }) do
    log(:req, %{handling: "FROM_ROOT_NO_SLOTS", data: body})

    body

    log(:res, %{handling: "FROM_ROOT_NO_SLOTS", data: body})
  end

  def render("query.json", %{request: body}) do
    log(:req, %{handling: "NO MATCH", data: body})

    body

    log(:res, %{handling: "NO MATCH", data: body})
  end

  defp log(reqres, %{handling: handling, data: data}) do
    label = Map.get(%{req: "REQUEST", res: "RESPONSE"}, reqres)
    Logger.info("HANDLING: #{handling}")
    Logger.info("#{label} DATA: #{Jason.encode!(data)}")
  end
end
