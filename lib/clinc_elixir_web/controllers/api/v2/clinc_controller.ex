defmodule ClincElixirWeb.Api.V2.ClincController do
  use ClincElixirWeb, :controller

  def query(conn, params) do
    render(conn, "query.json", request: atomize(params))
  end

  defp atomize(%{} = params) do
    for {key, val} <- params,
        into: %{},
        do: {String.to_atom(key), atomize(val)}
  end

  defp atomize([h | t]) do
    [atomize(h) | atomize(t)]
  end

  defp atomize(x), do: x
end
