defmodule ExpertsWeb.QuestionController do
  use ExpertsWeb, :controller
  alias Experts.Posts

  @moduledoc """
  A controller for managing questions.

  All visitors can see a list of questions and a question page. Only registered users can post questions. Only a user
  who created a question can edit or delete it.

  The `question#show` page displays a question, a list of answers and a form to write an answer. A form to write an
  answer is visible only to a registered user. Other visitors see a link to login or to become a member.
  """

  def index(conn, _params) do
    questions = Posts.list_questions()

    render(conn, "index.html", questions: questions)
  end

  def show(conn, %{"id" => id}) do
    case Posts.get_question(id) do
      nil ->
        conn
        |> put_flash(:info, "Question was not found.")
        |> redirect(to: Routes.question_path(conn, :index))

      question ->
        answers = Posts.list_answers(question)
        new_answer_changeset = Posts.new_answer()

        render(conn, "show.html",
          question: question,
          answers: answers,
          new_answer_changeset: new_answer_changeset
        )
    end
  end

  def new(conn, _params) do
    changeset = Posts.new_question()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"question" => question_attrs}) do
    user = Pow.Plug.current_user(conn)

    case Posts.create_question(user, question_attrs) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "The question is posted.")
        |> redirect(to: Routes.question_path(conn, :show, question.id))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    changeset = Posts.edit_question(user, id)

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "question" => attrs}) do
    user = Pow.Plug.current_user(conn)

    case(Posts.update_question(user, id, attrs)) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "The question was updated!")
        |> redirect(to: Routes.question_path(conn, :show, question.id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    conn
    |> Pow.Plug.current_user()
    |> Posts.delete_question(id)

    conn
    |> put_flash(:info, "The question was deleted.")
    |> redirect(to: Routes.question_path(conn, :index))
  end
end
