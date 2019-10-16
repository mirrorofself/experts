defmodule ExpertsWeb.QuestionView do
  use ExpertsWeb, :view

  alias Experts.Posts.Question

  def can_manage?(conn, %Question{} = question) do
    case Pow.Plug.current_user(conn) do
      nil -> false
      user -> user.id == question.user.id
    end
  end
end
