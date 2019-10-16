defmodule ExpertsWeb.QuestionView do
  use ExpertsWeb, :view

  alias Experts.Posts.Question

  def can_manage?(conn, %Question{} = question) do
    Pow.Plug.current_user(conn).id == question.user.id
  end
end
