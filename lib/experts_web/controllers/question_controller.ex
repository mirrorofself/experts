defmodule ExpertsWeb.QuestionController do
  use ExpertsWeb, :controller
  alias Experts.Posts

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
        render(conn, "show.html", question: question)
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

    case Posts.edit_question(user, id) do
      :not_permitted ->
        conn
        |> put_flash(:warning, "You don't have access to the page.")
        |> redirect(to: Routes.question_path(conn, :index))

      {:ok, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "question" => attrs}) do
    user = Pow.Plug.current_user(conn)

    case(Posts.update_question(user, id, attrs)) do
      :not_permitted ->
        conn
        |> put_flash(:warning, "You don't have access to the page.")
        |> redirect(to: Routes.question_path(conn, :index))

      {:ok, question} ->
        conn
        |> put_flash(:info, "The question was updated!")
        |> redirect(to: Routes.question_path(conn, :show, question.id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)

    case Posts.delete_question(user, id) do
      :not_permitted ->
        conn
        |> put_flash(:warning, "You don't have access to the page.")
        |> redirect(to: Routes.question_path(conn, :index))

      :ok ->
        conn
        |> put_flash(:info, "The question was deleted.")
        |> redirect(to: Routes.question_path(conn, :index))
    end
  end
end
