defmodule Ping.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :dream, :string
      add :reality, :string
      add :process, :integer

      timestamps()
    end

  end
end
