defmodule Experts.Posts.Question do
  @moduledoc """
  A schema for questions.
  """

  use Ecto.Schema

  alias Ecto.Changeset
  alias Experts.{Posts.Answer, Users.User}

  schema "questions" do
    belongs_to :user, User
    has_many :answers, Answer

    field :title
    field :slug
    field :body
    field :tags, Experts.EctoTag

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> Changeset.cast(attrs, [:title, :body, :tags])
    |> Changeset.validate_required([:title, :body])
  end
end
