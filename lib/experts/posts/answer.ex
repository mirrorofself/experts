defmodule Experts.Posts.Answer do
  @moduledoc """
  A schema for answers.
  """

  use Ecto.Schema

  alias Ecto.Changeset
  alias Experts.{Posts.Question, Users.User}

  schema "answers" do
    belongs_to :user, User
    belongs_to :question, Question

    field :body

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> Changeset.cast(attrs, [:body])
    |> Changeset.validate_required([:body])
  end
end
