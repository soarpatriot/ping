defmodule Ping.Repo.Migrations.AddCountToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do 
      add :count, :integer
    end
  end
end
