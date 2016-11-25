defmodule Ping.Repo.Migrations.ChangeUserColumn do
  use Ecto.Migration
  def change do
    rename table(:users), :sex, to: :gender
    rename table(:users), :headimgurl, to: :avatar_url

  end

end
