defmodule Pento.Repo.Migrations.AddUsernameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
    end

    create unique_index(:users, [:username])
  end

  def down do
    alter table(:users) do
      remove :username
    end

    drop unique_index(:users, [:username])
  end
end
