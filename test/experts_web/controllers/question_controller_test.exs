defmodule ExpertsWeb.QuestionControllerTest do
  use ExpertsWeb.ConnCase
  import Experts.Factory

  describe "index/2" do
    test "renders a list of questions", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Questions"
    end
  end

  describe "show/2" do
    setup do
      user = insert(:user)
      question = insert(:question, title: "Really?", user_id: user.id)
      answer = insert(:answer, body: "Sample answer.", question_id: question.id, user_id: user.id)

      {:ok, user: user, question: question, answer: answer}
    end

    test "renders a question", %{conn: conn, question: question} do
      conn = get(conn, "/questions/#{question.id}")

      assert html_response(conn, 200) =~ "Really?"
    end

    test "renders a list of answers", %{
      conn: conn,
      question: question
    } do
      conn = get(conn, "/questions/#{question.id}")

      assert html_response(conn, 200) =~ "Sample answer."
    end

    test "when logged out doesn't render a new answer form", %{
      conn: conn,
      question: question
    } do
      conn = get(conn, "/questions/#{question.id}")

      assert html_response(conn, 200) =~ "become a member"
    end

    test "when logged in renders a new answer form", %{
      conn: conn,
      user: user,
      question: question
    } do
      logged_in_conn = Plug.Conn.assign(conn, :current_user, user)

      conn = get(logged_in_conn, "/questions/#{question.id}")

      assert html_response(conn, 200) =~ "Post an answer"
    end
  end

  describe "new/2" do
    test "when logged in renders a form for a new question", %{conn: conn} do
      user = insert(:user)
      conn = Plug.Conn.assign(conn, :current_user, user)

      conn = get(conn, "/questions/new")
      assert html_response(conn, 200) =~ "Post a question"
    end

    test "when logged out doesn't render a form for a new question", %{conn: conn} do
      conn = get(conn, "/questions/new")
      assert html_response(conn, 200) =~ "become a member"
    end
  end

  describe "create/2" do
    setup %{conn: conn} do
      user = insert(:user)
      new_conn = Plug.Conn.assign(conn, :current_user, user)

      {:ok, conn: new_conn}
    end

    test "when succeeds redirect to a question page", %{conn: conn} do
      valid_params = %{
        "question" => %{
          "title" => "S",
          "body" => "S",
          "tags" => "architecture, books"
        }
      }

      posted_conn = post(conn, "/questions", valid_params)

      assert %{id: id} = redirected_params(posted_conn)
      assert redirected_to(posted_conn) == "/questions/#{id}"

      get_conn = get(conn, "/questions/#{id}")

      assert html_response(get_conn, 200) =~ "Question Page"
    end

    test "when fails display errors", %{conn: conn} do
      invalid_params = %{
        "question" => %{
          "title" => "",
          "body" => "T"
        }
      }

      posted_conn = post(conn, "/questions", invalid_params)

      assert html_response(posted_conn, 200) =~ "New Question"
    end
  end

  describe "edit/2" do
    setup %{conn: conn} do
      user = insert(:user)
      new_conn = Plug.Conn.assign(conn, :current_user, user)

      {:ok, conn: new_conn}
    end

    test "with authorized user renders an edit form", %{conn: conn} do
      question = insert(:question, user_id: conn.assigns.current_user.id)

      edit_question_conn = get(conn, "/questions/#{question.id}/edit")

      assert html_response(edit_question_conn, 200) =~ "Edit Question"
    end
  end

  describe "update/2" do
    setup %{conn: conn} do
      user = insert(:user)
      new_conn = Plug.Conn.assign(conn, :current_user, user)

      {:ok, conn: new_conn}
    end

    test "with valid attrs sets a flash message and redirects to a question page", %{conn: conn} do
      question = insert(:question, user_id: conn.assigns.current_user.id)
      attrs = %{"question" => %{"title" => "Updated title", "body" => "Updated body"}}

      update_conn = put(conn, "/questions/#{question.id}", attrs)

      assert get_flash(update_conn, :info) == "The question was updated!"
      assert redirected_to(update_conn) == "/questions/#{question.id}"

      show_conn = get(conn, "/questions/#{question.id}")

      assert html_response(show_conn, 200) =~ "Updated title"
    end

    test "with invalid attrs renders an edit form with errors", %{conn: conn} do
      question = insert(:question, user_id: conn.assigns.current_user.id)
      attrs = %{"question" => %{"title" => ""}}

      update_conn = put(conn, "/questions/#{question.id}", attrs)

      assert html_response(update_conn, 200) =~ "Edit Question"
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      user = insert(:user)
      new_conn = Plug.Conn.assign(conn, :current_user, user)

      {:ok, conn: new_conn}
    end

    test "sets a flash message and redirects to a list of questions", %{conn: conn} do
      question = insert(:question, user_id: conn.assigns.current_user.id)

      delete_conn = delete(conn, "/questions/#{question.id}")

      assert get_flash(delete_conn, :info) == "The question was deleted."
      assert redirected_to(delete_conn) == "/"
    end
  end
end
