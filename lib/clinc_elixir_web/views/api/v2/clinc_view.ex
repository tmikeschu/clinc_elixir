defmodule ClincElixirWeb.Api.V2.ClincView do
  use ClincElixirWeb, :view
  # alias ClincElixirWeb.Api.V2.{}

  @renderers %{}

  def render("query.json", data = %{request: %{state: state}}) do
    Map.fetch!(@renderers, state).render(data)
  end
end
