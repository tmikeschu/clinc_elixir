defmodule ClincElixirWeb.Api.V1.Default do
  use ClincElixirWeb.Api.V1.Renderer

  def render(%{request: request}) do
    request
    |> log(:req, "EMPTY")
    |> log(:res, "EMPTY")
  end
end
