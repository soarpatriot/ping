defmodule Ping.Repo.Migrations.ChangeGenderTypeInUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :gender
    end
    alter table(:users) do 
      add :gender, :integer
    end

  end
end
