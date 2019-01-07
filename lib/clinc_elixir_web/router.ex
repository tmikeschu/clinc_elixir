defmodule ClincElixirWeb.Router do
  use ClincElixirWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ClincElixirWeb do
    pipe_through :api

    scope "/v1", Api.V1, as: :v1 do
      post "/clinc/query", ClincController, :query
    end
  end
end
