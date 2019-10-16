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
