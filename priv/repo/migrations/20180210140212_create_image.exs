defmodule Ping.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :key, :string
      add :hash, :string
      add :url, :string
      add :post_id, references(:posts, on_delete: :nothing)

      timestamps()
    end
    create index(:images, [:post_id])

  end
end
