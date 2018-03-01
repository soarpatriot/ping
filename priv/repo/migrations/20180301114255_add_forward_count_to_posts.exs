defmodule Ping.Repo.Migrations.AddForwardCountToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do 
      add :forward_count, :integer, default: 0
    end
  end
end
