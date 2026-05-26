defmodule Pento.Repo.Migrations.CreateFaqs do
  use Ecto.Migration

  def change do
    create table(:faqs) do
      add :question, :string
      add :answer, :text
      add :votes, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
