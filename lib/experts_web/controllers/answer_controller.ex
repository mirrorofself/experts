defmodule ExpertsWeb.AnswerController do
  use ExpertsWeb, :controller
  alias Experts.Posts

  @moduledoc """
  All actions are expected to be called with XMLHttpRequest requests. They render server generated
  javascript responses. Javascript code in a response is executed in a browser. Rails UJS is used to make
  these requests in the views - https://github.com/rails/rails/tree/master/actionview/app/assets/javascripts.

  For more info about this technique, take a look at - https://signalvnoise.com/posts/3697-server-generated-javascript-responses.

  Edit, update and delete actions will raise an error if an author of an answer is not a current user. These errors
  aren't rescued intentionally, because they indicate an error in the views.
  """

  def show(conn, %{"id" => id}) do
    answer = Posts.get_answer(id)

    render(conn, "show.js", answer: answer)
  end

  def create(conn, %{"question_id" => question_id, "answer" => attrs}) do
    user = Pow.Plug.current_user(conn)
    question = Posts.get_question(question_id)

    case Posts.create_answer(user, question, attrs) do
      {:ok, answer} ->
        changeset = Posts.new_answer()

        render(conn, "create.js", answer: answer, changeset: changeset, question: question)

      {:error, changeset} ->
        render(conn, "new.js", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    changeset = Posts.edit_answer(user, id)

    render(conn, "edit.js", changeset: changeset)
  end

  def update(conn, %{"id" => id, "answer" => attrs}) do
    user = Pow.Plug.current_user(conn)

    case Posts.update_answer(user, id, attrs) do
      {:ok, answer} ->
        render(conn, "show.js", answer: answer)

      {:error, changeset} ->
        render(conn, "edit.js", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    Posts.delete_answer!(user, id)

    render(conn, "delete.js", answer_id: id)
  end
end
