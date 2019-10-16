defmodule ExpertsWeb.QuestionControllerTest do
  use ExpertsWeb.ConnCase
  import Experts.Factory

  setup %{conn: conn} do
    user = insert(:user)
    new_conn = Plug.Conn.assign(conn, :current_user, user)

    {:ok, conn: new_conn}
  end

  describe "index/2" do
    test "renders a list of questions", %{conn: conn} do
      conn = get(conn, "/questions")
      assert html_response(conn, 200) =~ "Questions"
    end
  end

  describe "show/2" do
    setup %{conn: %{assigns: %{current_user: user}}} do
      question = insert(:question, title: "Really?", user_id: user.id)

      {:ok, question: question}
    end

    test "renders a question", %{conn: conn, question: question} do
      conn = get(conn, "/questions/#{question.id}")

      assert html_response(conn, 200) =~ "Really?"
    end
  end

  describe "new/2" do
    test "renders a form for a new question", %{conn: conn} do
      conn = get(conn, "/questions/new")
      assert html_response(conn, 200) =~ "New Question"
    end
  end

  describe "create/2" do
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
    test "with unauthorized user redirects to a list of questions", %{
      conn: conn
    } do
      unauthorized_user = insert(:user, email: "unauthorized.user@example.com")
      question = insert(:question, user_id: unauthorized_user.id)

      conn = get(conn, "/questions/#{question.id}/edit")

      assert get_flash(conn, :warning) == "You don't have access to the page."
      assert redirected_to(conn) == "/questions"
    end

    test "with authorized user renders an edit form", %{conn: conn} do
      question = insert(:question, user_id: conn.assigns.current_user.id)

      edit_question_conn = get(conn, "/questions/#{question.id}/edit")

      assert html_response(edit_question_conn, 200) =~ "Edit Question"
    end
  end

  describe "update/2" do
    test "with unauthorized user redirects to a list of questions", %{
      conn: conn
    } do
      unauthorized_user = insert(:user, email: "unauthorized.user@example.com")
      question = insert(:question, user_id: unauthorized_user.id)

      update_conn = put(conn, "/questions/#{question.id}", %{"question" => %{}})

      assert get_flash(update_conn, :warning) == "You don't have access to the page."
      assert redirected_to(update_conn) == "/questions"
    end

    test "with authorized user and valid attrs updates a question", %{conn: conn} do
      question = insert(:question, user_id: conn.assigns.current_user.id)
      attrs = %{"question" => %{"title" => "Updated title", "body" => "Updated body"}}

      update_conn = put(conn, "/questions/#{question.id}", attrs)

      assert redirected_to(update_conn) == "/questions/#{question.id}"

      show_conn = get(conn, "/questions/#{question.id}")

      assert html_response(show_conn, 200) =~ "Updated title"
    end

    test "with authorized user and invalid attrs updates a question", %{conn: conn} do
      question = insert(:question, user_id: conn.assigns.current_user.id)
      attrs = %{"question" => %{"title" => ""}}

      update_conn = put(conn, "/questions/#{question.id}", attrs)

      assert html_response(update_conn, 200) =~ "Edit Question"
    end
  end

  describe "delete/2" do
    test "with unauthorized user redirects to a list of questions", %{
      conn: conn
    } do
      unauthorized_user = insert(:user, email: "unauthorized.user@example.com")
      question = insert(:question, user_id: unauthorized_user.id)

      delete_conn = delete(conn, "/questions/#{question.id}")

      assert get_flash(delete_conn, :warning) == "You don't have access to the page."
      assert redirected_to(delete_conn) == "/questions"
    end

    test "with authorized user deletes a question", %{conn: conn} do
      question = insert(:question, user_id: conn.assigns.current_user.id)

      delete_conn = delete(conn, "/questions/#{question.id}")

      assert get_flash(delete_conn, :info) == "The question was deleted."
      assert redirected_to(delete_conn) == "/questions"
    end
  end
end
