defmodule Experts.Factory do
  @moduledoc """
  Sample data factories used in tests and in the seed file.
  """

  use ExMachina.Ecto, repo: Experts.Repo
  alias Experts.{Posts.Answer, Posts.Question, Users.User}
  alias Pow.Ecto.{Schema.Password}

  def user_factory do
    password_hash = Password.pbkdf2_hash("Secret1234")

    %User{
      name: "Christopher Alexander",
      email: "chris@example.com",
      password_hash: password_hash
    }
  end

  def question_factory(attrs) do
    question = %Question{
      title: "What book should I read this winter?",
      slug: "what-book-should-i-read-this-winter",
      body: "I want to expand my knowledge on the subject...",
      tags: "architecture, books"
    }

    merge_attributes(question, attrs)
  end

  def answer_factory(attrs) do
    answer = %Answer{
      body: "Take a look at the book..."
    }

    merge_attributes(answer, attrs)
  end
end
