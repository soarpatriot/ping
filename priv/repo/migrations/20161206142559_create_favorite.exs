defmodule Ping.Repo.Migrations.CreateFavorite do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add :user_id, :integer
      add :post_id, :integer

      timestamps()
    end

  end
end
