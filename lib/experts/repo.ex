defmodule Experts.Repo do
  use Ecto.Repo,
    otp_app: :experts,
    adapter: Ecto.Adapters.Postgres
end
