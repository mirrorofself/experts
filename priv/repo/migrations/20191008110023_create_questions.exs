defmodule Experts.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :user_id, references(:users), null: false

      add :title, :string, null: false
      add :slug, :string, null: false
      add :body, :text, null: false
      add :tags, {:array, :string}

      timestamps()
    end
  end
end
