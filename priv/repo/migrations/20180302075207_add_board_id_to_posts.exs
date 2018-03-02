defmodule Ping.Repo.Migrations.AddBoardIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do 
      add :board_id, :integer, default: 0
    end
 
  end
end
