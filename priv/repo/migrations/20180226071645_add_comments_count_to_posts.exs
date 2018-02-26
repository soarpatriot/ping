defmodule Ping.Repo.Migrations.AddCommentsCountToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do 
      add :comments_count, :integer
    end


  end
end
