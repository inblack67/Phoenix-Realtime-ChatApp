defmodule Phoex.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, null: false, size: 30
      add :description, :string
      add :topic, :string, size: 300

      timestamps()
    end

    create unique_index(:rooms, [:name])

  end
end
