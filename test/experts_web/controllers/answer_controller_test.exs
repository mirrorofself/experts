defmodule ExpertsWeb.AnswerControllerTest do
  use ExpertsWeb.ConnCase
  import Experts.Factory

  describe "show/2" do
    setup %{conn: conn} do
      user = insert(:user)
      question = insert(:question, user_id: user.id)

      answer =
        insert(:answer, body: "Sample answer body.", question_id: question.id, user_id: user.id)

      {:ok, answer: answer, conn: Plug.Conn.assign(conn, :current_user, user)}
    end

    test "renders a JSR that changes an edit form to an answer", %{conn: conn, answer: answer} do
      conn = get(conn, "/answers/#{answer.id}")

      assert response_content_type(conn, :js)
      assert response(conn, 200) =~ "$(\"#edit_answer_#{answer.id}\").html("
      assert response(conn, 200) =~ "Sample answer body."
    end
  end

  # TODO: add answer controller tests
  describe "create/2" do
    test "with valid attrs renders a JSR that adds an answer to a list and re-renders a new form" do
    end

    test "with invalid attrs renders a JSR that updates a new form with errors" do
    end
  end

  describe "edit/2" do
    test "renders a JSR that changes an answer to an edit form" do
    end
  end

  describe "update/2" do
    test "with valid attrs renders a JSR that replaces an edit form with an updated answer" do
    end

    test "with invalid attrs renders a JSR that replaces an edit form with an edit form with errors" do
    end
  end

  describe "delete/2" do
    test "renders a JSR that fades out the answer from a list" do
    end
  end
end
