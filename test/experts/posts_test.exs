defmodule Experts.PostsTest do
  use Experts.DataCase
  import Experts.Factory

  alias Experts.{Posts, Posts.Question}

  describe "list_questions/0" do
    setup do
      user = insert(:user)

      question1 =
        insert(:question,
          title: "Question 1?",
          slug: "question-1",
          body: "Body1",
          user_id: user.id
        )

      question2 =
        insert(:question,
          title: "Question 2?",
          slug: "question-2",
          body: "Body2",
          user_id: user.id
        )

      {:ok, question1: question1, question2: question2}
    end

    test "returns a list of questions in chronological order", %{
      question1: question1,
      question2: question2
    } do
      questions_ids = Enum.map(Posts.list_questions(), fn question -> question.id end)

      assert questions_ids == [question1.id, question2.id]
    end
  end

  describe "get_question/1" do
    # TODO: fix difference in returned value of tags (change EctoTag, perhaps implement a new form input helper)
    @tag :skip
    test "with existing id returns a question" do
      user = insert(:user)

      question =
        insert(:question,
          title: "Question 1?",
          slug: "question-1",
          body: "Body1",
          user_id: user.id
        )

      expected = Posts.get_question(question.id)

      assert expected == question
      # assert expected.tags == question.tags
    end

    test "with non-existing id returns a nil" do
      assert Posts.get_question(1) == nil
    end
  end

  describe "new_question/0" do
    test "returns an empty changeset" do
      changeset = Posts.new_question()

      assert %Ecto.Changeset{data: %Question{}, action: nil} = changeset
    end
  end

  describe "create_question/2" do
    setup :insert_user

    test "with valid attrs returns a question", %{user: user} do
      attrs = %{
        "title" => "Title Sample",
        "body" => "Body sample.",
        "tags" => "architecture, books"
      }

      {:ok, question} = Posts.create_question(user, attrs)

      assert question.title == "Title Sample"
      assert question.slug == "title-sample"
      assert question.body == "Body sample."
      assert question.tags == ["architecture", "books"]
      assert question.user_id == user.id
    end

    test "with invalid attrs returns validation errors", %{user: user} do
      attrs = %{"title" => "", "body" => "", "tags" => ""}

      {:error, changeset} = Posts.create_question(user, attrs)

      assert changeset.errors == [
               title: {"can't be blank", [validation: :required]},
               body: {"can't be blank", [validation: :required]}
             ]
    end
  end

  describe "edit_question/3" do
    setup do
      user = insert(:user)
      question = insert(:question, user_id: user.id)

      {:ok, user: user, question: question}
    end

    test "with unauthorized user returns not permitted", %{question: question} do
      unauthorized_user = insert(:user, email: "unauthorized-user@example.com")

      assert Posts.edit_question(unauthorized_user, question.id) == :not_permitted
    end

    test "with authorized user returns a changeset", %{user: user, question: question} do
      {:ok, changeset} = Posts.edit_question(user, question.id)

      assert changeset.data.id == question.id
    end
  end

  describe "update_question/3" do
    setup do
      user = insert(:user)
      question = insert(:question, user_id: user.id)

      {:ok, user: user, question: question}
    end

    test "with unauthorized user returns not permitted", %{question: question} do
      unauthorized_user = insert(:user, email: "unauthorized-user@example.com")
      attrs = %{"title" => "Updated"}

      assert Posts.update_question(unauthorized_user, question.id, attrs) == :not_permitted
    end

    test "with valid attrs returns a question", %{user: user, question: question} do
      attrs = %{
        "title" => "Updated Title",
        "body" => "Updated body",
        "tags" => "updated_tag1, updated_tag2"
      }

      {:ok, question} = Posts.update_question(user, question.id, attrs)

      assert question.title == "Updated Title"
      assert question.body == "Updated body"
      assert question.tags == ["updated_tag1", "updated_tag2"]
    end

    test "with invalid attrs returns validation errors", %{user: user, question: question} do
      attrs = %{
        "title" => "",
        "body" => "",
        "tags" => ""
      }

      {:error, changeset} = Posts.update_question(user, question.id, attrs)

      assert changeset.errors == [
               title: {"can't be blank", [validation: :required]},
               body: {"can't be blank", [validation: :required]}
             ]
    end
  end

  describe "delete_question/2" do
    setup do
      user = insert(:user)
      question = insert(:question, user_id: user.id)

      {:ok, user: user, question: question}
    end

    test "with unauthorized user returns not permitted", %{question: question} do
      unauthorized_user = insert(:user, email: "unauthorized-user@example.com")

      assert Posts.delete_question(unauthorized_user, question.id) == :not_permitted
    end

    test "with authorized user returns ok", %{user: user, question: question} do
      assert Posts.delete_question(user, question.id) == :ok
    end

    test "with authorized user deletes a question", %{user: user, question: question} do
      Posts.delete_question(user, question.id)

      assert Repo.get(Question, question.id) == nil
    end
  end

  def insert_user(_context) do
    user = insert(:user)

    {:ok, %{user: user}}
  end
end
