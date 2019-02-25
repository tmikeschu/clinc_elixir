defmodule ClincElixirWeb.Api.V1.Default do
  use ClincElixirWeb.Api.V1.Renderer

  def render(_) do
    %{}
    |> log(:req, "EMPTY")
    |> log(:res, "EMPTY")
  end
end
