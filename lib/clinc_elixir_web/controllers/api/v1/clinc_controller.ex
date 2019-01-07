defmodule ClincElixirWeb.Api.V1.ClincController do
  use ClincElixirWeb, :controller

  require Logger

  def query(conn, params) do
    render(conn, "query.json", request: atomify(params))
  end

  defp atomify(params) do
    for {key, val} <- params,
        into: %{},
        do: {String.to_atom(key), val}
  end
end
