defmodule Ping.Repo do
  use Ecto.Repo, otp_app: :ping
  use Kerosene, per_page: 2
end
