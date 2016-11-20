defmodule Ping.Repo.Migrations.ChangeProcessOfPost do
  use Ecto.Migration

  def change do
    rename table(:posts), :process, to: :progress
  end
end
