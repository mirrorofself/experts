defmodule Experts.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :user_id, references(:users), null: false
      add :question_id, references(:questions, on_delete: :delete_all), null: false

      add :body, :text, null: false

      timestamps()
    end
  end
end
