defmodule Ping.Repo.Migrations.AddCityToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do 
      add :city, :string
    end
 
  end
end
