defmodule Ping.Repo.Migrations.ModifyCommentsCountToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do 
      modify :comments_count, :integer, default: 0
    end


  end
end
