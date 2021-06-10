defmodule Phoex.Repo do
  use Ecto.Repo,
    otp_app: :phoex,
    adapter: Ecto.Adapters.Postgres
end
