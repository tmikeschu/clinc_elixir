defmodule ClincElixir.Repo do
  use Ecto.Repo,
    otp_app: :clinc_elixir,
    adapter: Ecto.Adapters.Postgres
end
