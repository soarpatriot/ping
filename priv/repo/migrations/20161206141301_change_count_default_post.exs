defmodule Ping.Repo.Migrations.ChangeCountDefaultPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do 
      modify :count, :integer, default: 0
    end

  end
end
