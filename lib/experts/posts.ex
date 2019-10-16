defmodule Experts.Posts do
  @moduledoc """
  Questions and answers related context.
  """

  alias Experts.{Posts.Answer, Posts.Question, Repo}
  alias Ecto.{Changeset}
  import Ecto.Query

  @doc """
  Returns a list of questions.
  """
  def list_questions do
    Question
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a question.
  """
  def get_question(id) do
    Repo.get(Question, id)
  end

  @doc """
  Builds a changeset for a new question form.
  """
  def new_question do
    Question.changeset(%Question{}, %{})
  end

  @doc """
  Creates a question.

  A user and a slug are required question fields that are set directly on the changeset without being cast.
  """
  def create_question(user, attrs) do
    slug = Slug.slugify(attrs["title"])

    %Question{}
    |> Changeset.change(user_id: user.id, slug: slug)
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Builds a changeset for an edit form.

  Only a user who created a question has permissions to edit it.

  If a user didn't create a question, we return a `:not_permitted` error.
  """
  def edit_question(user, id) do
    question = Repo.get_by(Question, id: id, user_id: user.id)

    case question do
      nil ->
        :not_permitted

      %Question{} ->
        {:ok, Question.changeset(question, %{})}
    end
  end

  @doc """
  Updates a question.
  """
  def update_question(user, id, attrs) do
    question = Repo.get_by(Question, id: id, user_id: user.id)

    case question do
      nil ->
        :not_permitted

      %Question{} ->
        question
        |> Question.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Deletes a question.
  """
  def delete_question(user, id) do
    question = Repo.get_by(Question, id: id, user_id: user.id)

    case question do
      nil ->
        :not_permitted

      %Question{} ->
        Repo.delete!(question)
        :ok
    end
  end
end
