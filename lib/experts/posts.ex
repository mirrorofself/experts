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
    |> preload(:user)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a question.
  """
  def get_question(id) do
    Question
    |> preload(:user)
    |> Repo.get(id)
  end

  @doc """
  Builds a changeset for a new question form.
  """
  def new_question do
    Question.changeset(%Question{}, %{})
  end

  @doc """
  Creates a question.

  A user and a slug are required question fields that are set directly on the changeset.
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

  Only a user who created a question can edit it. Otherwise an error is raised.
  """
  def edit_question(user, id) do
    Question
    |> Repo.get_by!(id: id, user_id: user.id)
    |> Question.changeset(%{})
  end

  @doc """
  Updates a question.

  Only a user who created a question can update it. Otherwise an error is raised.
  """
  def update_question(user, id, attrs) do
    Question
    |> Repo.get_by!(id: id, user_id: user.id)
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question.

  Only a user who created a question can delete it. Otherwise an error is raised.
  """
  def delete_question(user, id) do
    Question
    |> Repo.get_by!(id: id, user_id: user.id)
    |> Repo.delete!()
  end

  @doc """
  Lists answers.
  """
  def list_answers(question) do
    Answer
    |> where(question_id: ^question.id)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Gets an answer.
  """
  def get_answer(id) do
    Answer
    |> preload(:user)
    |> Repo.get!(id)
  end

  @doc """
  A changeset for a new answer.
  """
  def new_answer do
    Answer.changeset(%Answer{}, %{})
  end

  @doc """
  Creates an answer associated with an author and a question.
  """
  def create_answer(user, question, attrs) do
    answer =
      %Answer{}
      |> Changeset.change(user_id: user.id, question_id: question.id)
      |> Answer.changeset(attrs)
      |> Repo.insert()

    case answer do
      {:ok, answer} ->
        answer = Repo.preload(answer, :user)
        {:ok, answer}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Edit answer changeset.
  """
  def edit_answer(user, id) do
    answer =
      Answer
      |> preload(:user)
      |> Repo.get_by!(id: id, user_id: user.id)

    Answer.changeset(answer, %{})
  end

  @doc """
  Updates an answer.
  """
  def update_answer(user, id, attrs) do
    Answer
    |> preload(:user)
    |> Repo.get_by!(id: id, user_id: user.id)
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an answer.
  """
  def delete_answer!(user, id) do
    answer = Repo.get_by(Answer, id: id, user_id: user.id)

    Repo.delete!(answer)
  end
end
